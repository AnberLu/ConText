####  Change CUDA_PATH and -gencode options in CFLAGS1 if necessary. 
####
####  This makefile works fine with CUDA 7.5 and Tesla/Maxwell GPUs. 
####
####  If your CUDA version is older, you may need to remove some "-gencode" 
####  line(s) that your CUDA does not support, to avoid compile error. 
####
####  If the compute capability of your GPU card is 6.0 or higher, 
####  you need to add a "-gencode" line for it. 
####
####  The compute capability can be found by looking up Wikipedia:
####       https://en.wikipedia.org/wiki/CUDA . 
####  It can be also found by entering "gpuDevice" in matlab.  
####
####--------------------------------------------------------------------------
####  NOTE: This makefile is for GitHub users only.  In addition to compiling 
####    source code, it decompresses sample text files by "tar -xvf" and makes
####    shell script files executable by "chmod +x".  These additional actions
####    are for going around GitHub restrictions.  If they cause any trouble, 
####    please try the archive at riejohnson.com/cnn_download.html#download
####    instead of GitHub.  
####--------------------------------------------------------------------------

BIN_NAME1 = reNet
BIN_DIR = bin
TARGET1 = $(BIN_DIR)/$(BIN_NAME1)

CUDA_PATH       = /usr/local/cuda  # <= Change this 
#CUDA_PATH = /opt/sw/packages/cuda/7.5
CUDA_INC_PATH   = $(CUDA_PATH)/include
CUDA_BIN_PATH   = $(CUDA_PATH)/bin
CUDA_LIB_PATH   = $(CUDA_PATH)/lib64
LDFLAGS1   = -L$(CUDA_LIB_PATH) -lcudart -lcublas -lcurand -lcusparse
CFLAGS1 = -Isrc/com -Isrc/data -Isrc/nnet  -D__AZ_SMAT_SINGLE__ -D__AZ_GPU__  -I$(CUDA_INC_PATH) -O2 \
                -gencode arch=compute_20,code=sm_20 \
		-gencode arch=compute_20,code=sm_21 \
		-gencode arch=compute_30,code=sm_30 \
		-gencode arch=compute_32,code=sm_32 \
		-gencode arch=compute_35,code=sm_35 \
		-gencode arch=compute_37,code=sm_37 \
		-gencode arch=compute_50,code=sm_50 \
		-gencode arch=compute_52,code=sm_52 \
		-gencode arch=compute_53,code=sm_53

CPP_FILES1= 	\
	src/com/AzDmat.cpp \
	src/com/AzParam.cpp \
	src/com/AzSmat.cpp \
	src/com/AzStrPool.cpp \
	src/com/AzTextMat.cpp \
	src/com/AzTools.cpp \
	src/com/AzUtil.cpp \
	src/nnet/AzpPatchDflt.cpp \
	src/nnet/AzpReNet.cpp \
	src/nnet/AzpReLayer.cpp \
	src/nnet/AzMultiConn.cpp \
	src/nnet/AzpMain_reNet.cpp \
	src/nnet/AzpLmSgd.cpp \
	src/nnet/AzPmat.cpp \
	src/nnet/AzPmatSpa.cpp \
	src/nnet/AzPmatApp.cpp \
	src/nnet/AzPmat_gpu.cu \
	src/nnet/AzPmatSpa_gpu.cu \
	src/nnet/AzCuda_Pmat.cu \
	src/nnet/AzCuda_PmatSpa.cu \
	src/nnet/AzCuda_PmatApp.cu \
	src/nnet/AzpEv.cpp \
	src/nnet/AzpLossDflt.cpp \
	src/nnet/driv_reNet.cpp


BIN_NAME2 = prepText
TARGET2 = $(BIN_DIR)/$(BIN_NAME2)
CFLAGS2 = -Isrc/com -O2 -D__AZ_SMAT_SINGLE__

CPP_FILES2= 	\
	src/com/AzDmat.cpp \
	src/com/AzParam.cpp \
	src/com/AzSmat.cpp \
	src/com/AzStrPool.cpp \
	src/com/AzTools.cpp \
	src/com/AzTextMat.cpp \
	src/com/AzUtil.cpp \
	src/data/AzPrepText.cpp \
	src/data/AzTools_text.cpp \
	src/data/driv_PrepText.cpp


TARGET0 = examples/data/imdb-train.txt.tok

all: $(TARGET1) $(TARGET2) $(TARGET0) 

${TARGET0}:
	tar -xvf imdb-data.tar.gz
	chmod +x examples/*.sh
	chmod +x examples/other-sh/*.sh

${TARGET1}:
	mkdir -p bin 
	/bin/rm -f $(TARGET1)
	$(CUDA_BIN_PATH)/nvcc $(CPP_FILES1) $(CFLAGS1) -o $(TARGET1) $(LDFLAGS1)

${TARGET2}:
	/bin/rm -f $(TARGET2)
	g++ $(CPP_FILES2) $(CFLAGS2) -o $(TARGET2)

clean: 
	/bin/rm -f $(TARGET1)
	/bin/rm -f $(TARGET2)

cleandata:
	/bin/rm -f $(TARGET0)
