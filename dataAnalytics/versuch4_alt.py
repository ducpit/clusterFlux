import matplotlib.pyplot as plt
import matplotlib.dates as mdates

import pandas as pd
import json


startTime = '15:42'
endTime = '16:16'

timestamps = []
cpu_load = []
iowait = []
idle = []
rtps = []
wtps = []
dtps = []
bread_s = []
bwrtn_s = []
bdscd_s = []
rxerr_s = []
txerr_s = []
memused = []
commit = []
rxkB_s = []
txkB_s = []
scall_s = []
badcall_s = []
hit_s = []
miss_s = []
# ------------------ CPU ---------------
# %iowait Percentage of time that the CPU or CPUs were idle during which the system had an outstanding disk I/O request.
# %idle Percentage of time that the CPU or CPUs were idle and the system did not have an outstanding disk I/O request.
# ------------------ memory ---------------
# %memused Percentage of used memory.
# ------------------ physical device ---------------
# rtps Total number of read requests per second issued to physical devices.
# wtps Total number of write requests per second issued to physical devices.
# dtps Total number of discard requests per second issued to physical devices.
# bread/s Total amount of data read from the devices in blocks per second. Blocks are equivalent to sectors and therefore have a size of 512 bytes.
# bwrtn/s Total amount of data written to devices in blocks per second.
# bdscd/s Total amount of data discarded for devices in blocks per second.
# ------------------ Network ---------------
# rxerr/s Total number of bad packets received per second.
# txerr/s Total number of errors that happened per second while transmitting packets.
# rxkB/s Total number of kilobytes received per second.
# txkB/s Total number of kilobytes transmitted per second.
# ------------------ NFS ---------------

# scall/s Number of RPC requests received per second.
# badcall/s Number of bad RPC requests received per second, those whose processing generated an error.
# hit/s Number of reply cache hits per second.
# miss/s Number of reply cache misses per second.

with open("Versuche_08_altPC_gesamt.json") as data_file:    
    data = json.load(data_file)
data_file.close()


statistics = data["sysstat"]["hosts"][0]["statistics"]


for record in statistics:
    timestamps.append(record["timestamp"]["date"]+" "+record["timestamp"]["time"])
    idle.append(record["cpu-load"][0]["idle"])
    cpu_load.append(100 - record["cpu-load"][0]["idle"])
    iowait.append(record["cpu-load"][0]["iowait"])
    rtps.append(record["io"]["io-reads"]["rtps"])
    wtps.append(record["io"]["io-writes"]["wtps"])
    dtps.append(record["io"]["io-discard"]["dtps"])
    bread_s.append((512*10**(-7)*record["io"]["io-reads"]["bread"]))
    bwrtn_s.append((512*10**(-7)*record["io"]["io-writes"]["bwrtn"]))
    bdscd_s.append((512*10**(-7)*record["io"]["io-discard"]["bdscd"]))
    memused.append(record["memory"]["memused-percent"])
    commit.append(record["memory"]["commit-percent"]) 
    rxerr_s.append(record["network"]["net-edev"][0]["rxerr"])
    txerr_s.append(record["network"]["net-edev"][0]["txerr"])
    rxkB_s.append((record["network"]["net-dev"][0]["rxkB"])/125)
    txkB_s.append((record["network"]["net-dev"][0]["txkB"])/125)
    scall_s.append(record["network"]["net-nfsd"]["scall"])
    badcall_s.append(record["network"]["net-nfsd"]["badcall"])
    hit_s.append(record["network"]["net-nfsd"]["hit"])
    miss_s.append(record["network"]["net-nfsd"]["miss"]) 


df_cpu = pd.DataFrame({'Datetime':timestamps, 'cpu_load':cpu_load , 'idle': idle, 'iowait': iowait})
df_disk = pd.DataFrame({'Datetime':timestamps, 'rtps': rtps, 'wtps': wtps, 'dtps': dtps})
df_disk_data = pd.DataFrame({'Datetime':timestamps, 'bread_s': bread_s, 'bwrtn_s': bwrtn_s, 'bdscd_s': bdscd_s})
df_mem = pd.DataFrame({'Datetime':timestamps, 'memused':memused, 'commit-percent': commit })
df_net_err = pd.DataFrame({'Datetime':timestamps, 'rxerr_s': rxerr_s, 'txerr_s': txerr_s})
df_net = pd.DataFrame({'Datetime':timestamps, 'rxkB_s': rxkB_s, 'txkB_s': txkB_s})
df_net_rpc = pd.DataFrame({'Datetime':timestamps, 'scall_s': scall_s, 'badcall_s': badcall_s})
df_net_cache = pd.DataFrame({'Datetime':timestamps, 'hit_s': hit_s, 'miss_s': miss_s})


df_cpu['Datetime'] = pd.to_datetime(df_cpu['Datetime'])
df_cpu = df_cpu.set_index(df_cpu["Datetime"])
df_cpu.drop('Datetime',axis=1, inplace=True)

df_disk['Datetime'] = pd.to_datetime(df_disk['Datetime'])
df_disk = df_disk.set_index(df_disk["Datetime"])
df_disk.drop('Datetime',axis=1, inplace=True)

df_disk_data['Datetime'] = pd.to_datetime(df_disk_data['Datetime'])
df_disk_data = df_disk_data.set_index(df_disk_data["Datetime"])
df_disk_data.drop('Datetime',axis=1, inplace=True)

df_mem['Datetime'] = pd.to_datetime(df_mem['Datetime'])
df_mem = df_mem.set_index(df_mem["Datetime"])
df_mem.drop('Datetime',axis=1, inplace=True)

df_net['Datetime'] = pd.to_datetime(df_net['Datetime'])
df_net = df_net.set_index(df_net["Datetime"])
df_net.drop('Datetime',axis=1, inplace=True)

df_net_err['Datetime'] = pd.to_datetime(df_net_err['Datetime'])
df_net_err = df_net_err.set_index(df_net_err["Datetime"])
df_net_err.drop('Datetime',axis=1, inplace=True)

df_net_rpc['Datetime'] = pd.to_datetime(df_net_rpc['Datetime'])
df_net_rpc = df_net_rpc.set_index(df_net_rpc["Datetime"])
df_net_rpc.drop('Datetime',axis=1, inplace=True)

df_net_cache['Datetime'] = pd.to_datetime(df_net_cache['Datetime'])
df_net_cache = df_net_cache.set_index(df_net_cache["Datetime"])
df_net_cache.drop('Datetime',axis=1, inplace=True)

#define subplot layout, force subplots to have same y-axis scale
fig, axes = plt.subplots(nrows=8, ncols=1, sharey=False)
hourMinuteFmt = mdates.DateFormatter('%H:%M')

# -------- Versuch 1 ---------------
fig.suptitle('Analyse des Versuchs "Kubernetes+Boot" (PC 1)',y=0.992 ,fontsize=16)
fig.set_size_inches(10, 15)
""" ----- CPU -----"""
versuch1_cpu = df_cpu.between_time(startTime, endTime)
versuch1_cpu.plot(ax=axes[0],y = ['cpu_load','idle','iowait'],ylim=[0,110])
axes[0].set_title('CPU Statisktiken')
axes[0].set_xlabel('Uhrzeit')
axes[0].set_ylabel('%-Anteil-Zeit')
axes[0].xaxis.set_major_formatter(hourMinuteFmt)
axes[0].tick_params(axis='x', labelrotation=0)

""" ----- Memory -----"""
versuch1_mem = df_mem.between_time(startTime, endTime)
versuch1_mem.plot(ax=axes[1],y = ['memused','commit-percent'], ylim=[0,120])

axes[1].set_title('Speicherbenutzung')
axes[1].set_xlabel('Uhrzeit')
axes[1].set_ylabel('%-Anteil-Genutzt')
axes[1].xaxis.set_major_formatter(hourMinuteFmt)
axes[1].tick_params(axis='x', labelrotation=0)


""" ----- Disk Usage -----"""
versuch1_disk = df_disk.between_time(startTime, endTime)
versuch1_disk.plot(ax=axes[2],y = ['rtps','wtps','dtps'])
axes[2].set_title('Anfragen auf die Festplatte')
axes[2].set_xlabel('Uhrzeit')
axes[2].set_ylabel('Anfragen pro Sekunde')
axes[2].xaxis.set_major_formatter(hourMinuteFmt)
axes[2].tick_params(axis='x', labelrotation=0)


""" ----- Disk Data -----"""
versuch1_disk_data = df_disk_data.between_time(startTime, endTime)
versuch1_disk_data.plot(ax=axes[3],y = ['bread_s', 'bwrtn_s', 'bdscd_s'],ylim=[0,3])
axes[3].set_title('Auslastung der Festplatte')
axes[3].set_xlabel('Uhrzeit')
axes[3].set_ylabel('Gigabyte pro sec')
axes[3].xaxis.set_major_formatter(hourMinuteFmt)
axes[3].tick_params(axis='x', labelrotation=0)



""" ----- Network Trafic -----"""
versuch1_net = df_net.between_time(startTime, endTime)
versuch1_net.plot(ax=axes[4],y = ['rxkB_s', 'txkB_s'])
axes[4].set_title('Netwerkauslastung')
axes[4].set_xlabel('Uhrzeit')
axes[4].set_ylabel('Mbit pro sec')
axes[4].xaxis.set_major_formatter(hourMinuteFmt)
axes[4].tick_params(axis='x', labelrotation=0)



""" ----- Network Bad -----"""
versuch1_net_err = df_net_err.between_time(startTime, endTime)
versuch1_net_err.plot(ax=axes[5],y = ['rxerr_s', 'txerr_s'])
axes[5].set_title('Anzahl schlechter Packete')
axes[5].set_xlabel('Uhrzeit')
axes[5].set_ylabel('Anzahl')
axes[5].xaxis.set_major_formatter(hourMinuteFmt)
axes[5].tick_params(axis='x', labelrotation=0)

""" ----- RPC -----"""
versuch1_net_rpc = df_net_rpc.between_time(startTime, endTime)
versuch1_net_rpc.plot(ax=axes[6],y = ['scall_s', 'badcall_s'])
axes[6].set_title('Anzahl RPC Anfragen')
axes[6].set_xlabel('Uhrzeit')
axes[6].set_ylabel('Anzahl pro sec')
axes[6].xaxis.set_major_formatter(hourMinuteFmt)
axes[6].tick_params(axis='x', labelrotation=0)

""" ----- Cache -----"""
versuch1_cache = df_net_cache.between_time(startTime, endTime)
versuch1_cache.plot(ax=axes[7],y = ['hit_s', 'miss_s'])
axes[7].set_title('Cache')
axes[7].set_xlabel('Uhrzeit')
axes[7].set_ylabel('Anzahl pro sec')
axes[7].xaxis.set_major_formatter(hourMinuteFmt)
axes[7].tick_params(axis='x', labelrotation=0)


fig.tight_layout(pad=1)
fig.savefig('./img/versuch4_skal+komb_alt.png', dpi=100)

# -------- Versuch 1 ---------------

plt.show()
