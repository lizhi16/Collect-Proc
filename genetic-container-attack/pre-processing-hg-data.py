import multiprocessing
import numpy as np
from PIL import Image
from sklearn import preprocessing

filepath = "./tmp/"
picpath = "./pic-HGdata/"
features_channels = ["meminfo","loadavg","softirqs","buddyinfo"]
#pipeline_steps = ["step1","step2","step3","step4"]
pipeline_steps = ["HG00182",
        "HG00183",
        "HG00336",
        "HG00186",
        "HG00187",
        "HG00189",
        "HG00190",
        "HG00306",
        "HG00338",
        "HG00231",
        "HG00233",
        "HG00238",
        "HG00308"]

sample_number = 20
min_max_scaler = preprocessing.MinMaxScaler()

#calculate diffs
def diff(seq):
    ret = [0] #don't add 0 in there, else it will affect the normalized
    l = len(seq)
    for i in range(0,l-1):
        ret.append(seq[i+1] - seq[i])

    return ret

#def diff_one(seq,flag):
#    ret = np.array(diff(seq))
#    ret_diff = min_max_scaler.fit_transform(ret.reshape(-1,1))
#    results = [0.0]
#    
#    if flag == "MemFree:":
#        results = [100.0]
#    elif flag == "Cached:":
#        results = [101.0]
#    elif flag == "Active:":
#        results = [102.0]
#    elif flag == "AnonPages:":
#        results = [103.0]
#    elif flag == "alive":
#        results = [104.0]
#    elif flag == "proc":
#        results = [105.0]
#    elif flag == "NET_TX:":
#        results = [106.0]
#    elif flag == "NET_RX:":
#        results = [107.0]
#    elif flag == "SCHED:":
#        results = [108.0]
#    else:
#       results = [109.0]
#    
#
#    print (flag,len(ret_diff))
#    for i in range(len(ret_diff)):
#        results.append(float(ret_diff[i][0]))
#
#    return results

def diff_one(seq,flag):
    ret = np.array(diff(seq))
    print("channel: ",flag, "length: ", len(ret)+1)
    ret_diff = min_max_scaler.fit_transform(ret.reshape(-1,1))

    results = []
    for i in range(len(ret_diff)):
        results.append(ret_diff[i][0])

    return results


#resolving timelist to matrix
def reslove_side_channel(channeltype, step, num):
    channel = []

    if channeltype == "meminfo":
        #Input file path
        path = filepath + "meminfo-" + step + "-" + str(num)

        #in python3 use 'r' not use 'rb'
        with open(path,'r') as filemem:
            lines = filemem.readlines()

            ramlist = [int(line.strip().split()[1]) for line in lines if 'MemFree:' in line]
            channel.append(diff_one(ramlist,"MemFree:"))

            cachelist = [int(line.strip().split()[1]) for line in lines if 'Cached:' in line and 'SwapCached:' not in line]
            channel.append(diff_one(cachelist,"Cached:"))

            activelist = [int(line.strip().split()[1]) for line in lines if 'Active:' in line]
            channel.append(diff_one(activelist,"Active:"))

            anonlist = [int(line.strip().split()[1]) for line in lines if 'AnonPages:' in line]
            channel.append(diff_one(anonlist,"AnonPages:"))

        filemem.close()

    elif channeltype == "loadavg":
        #path = filepath + "loadavg-" + step + "-" + str(num)
        path = filepath + "loadavg-" + step + "-" + str(num)

        with open(path,'r') as filemem:
            lines = filemem.readlines()

            alivelist = [int(line.strip().split()[3].split('/')[1]) for line in lines]
            channel.append(diff_one(alivelist,"alive"))

            proclist = [int(line.strip().split()[3].split('/')[0]) for line in lines]
            channel.append(diff_one(proclist,"proc"))

        filemem.close()

    elif channeltype == "softirqs":
        path = filepath + "softirqs-" + step + "-" + str(num)
        #path = filepath + str(num) + "/softirqs-" + step 

        with open(path,'r') as filemem:
            lines = filemem.readlines()

            tx0list = [int(line.strip().split()[1]) for line in lines if 'NET_TX:' in line]
            channel.append(diff_one(tx0list,"NET_TX:"))

            rx0list = [int(line.strip().split()[1]) for line in lines if 'NET_RX:' in line]
            channel.append(diff_one(rx0list,"NET_RX:"))

            schedlist = [int(line.strip().split()[1]) for line in lines if 'SCHED:' in line]
            channel.append(diff_one(schedlist,"SCHED:"))

        filemem.close()

    elif channeltype == "zoneinfo":
        path = filepath + "zoneinfo-" + step + "-" + str(num)
        #path = filepath + str(num) + "/zoneinfo-" + step 

        with open(path,'r') as filemem:
            lines = filemem.readlines()
            #maplist = []
            #for index in range(len(lines)):
            #    if 'Node 0, zone   Normal' in lines[index]:
            #       maplist.append(int(lines[index+18].strip().split()[1]))
            maplist = [int(line.strip().split()[4]) for line in lines if 'Normal' in line] 
            channel.append(diff_one(maplist,"nr_mapped"))

        filemem.close()

    return channel


def resolve_timelist():
    channels_all = []

    cores = multiprocessing.cpu_count()
    pool = multiprocessing.Pool(processes=cores)

    for step in pipeline_steps:
        for num in range(1,sample_number + 1):
            paras = [(chan,step,num) for chan in features_channels]
            channel = pool.starmap(reslove_side_channel,paras)
            
            channels = []
            print (step, "-------", num)

            for proc_file in channel:
                #each tmp is a set of list related to features (meminfo, zoneinfo, ...)
                for para in proc_file:
                    # each c is a feature (MemFree: or Cached ...)
                    channels.append(para)

            pic = np.mat(channels)
            # Output file path and name
            im_path = picpath + step + "-" + str(num) + ".npy"
            print ("picture path: ", im_path)
            np.save(im_path,pic)
                
            channels_all.append(channels)

    #return channels_all

#def MatrixToImage(data):
#    data = data*255
#    new_im = Image.fromarray(data.astype(np.uint8))
#    return new_im

resolve_timelist()
