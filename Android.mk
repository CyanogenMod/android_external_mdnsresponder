LOCAL_PATH := $(call my-dir)

##########################

commonSources := \
    mDNSShared/dnssd_clientlib.c  \
    mDNSShared/dnssd_clientstub.c \
    mDNSShared/dnssd_ipc.c

commonLibs := libcutils liblog

commonFlags := -O2 -g -W -Wall -D__ANDROID__ -D_GNU_SOURCE -DHAVE_IPV6 \
    -DNOT_HAVE_SA_LEN -DUSES_NETLINK -DTARGET_OS_LINUX -fno-strict-aliasing \
    -DHAVE_LINUX -DMDNS_UDS_SERVERPATH=\"/dev/socket/mdnsd\" -DMDNS_DEBUGMSGS=0

include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(commonSources)
LOCAL_MODULE := libmdnssd
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS := $(commonFlags)
LOCAL_SYSTEM_SHARED_LIBRARIES := libc
LOCAL_SHARED_LIBRARIES := $(commonLibs)
LOCAL_EXPORT_C_INCLUDE_DIRS := external/mdnsresponder/mDNSShared
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(commonSources)
LOCAL_MODULE := libmdnssd
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS := $(commonFlags)
LOCAL_STATIC_LIBRARIES := $(commonLibs)
LOCAL_EXPORT_C_INCLUDE_DIRS := external/mdnsresponder/mDNSShared
include $(BUILD_STATIC_LIBRARY)

############################

include $(CLEAR_VARS)
LOCAL_SRC_FILES :=  Clients/dns-sd.c \
                    Clients/ClientCommon.c

LOCAL_MODULE := dnssd
LOCAL_MODULE_TAGS := optional

LOCAL_CFLAGS := $(commonFlags) -DMDNS_USERNAME=\"mdnsr\" -DPLATFORM_NO_RLIMIT

LOCAL_SYSTEM_SHARED_LIBRARIES := libc
LOCAL_SHARED_LIBRARIES := libmdnssd $(commonLibs)

include $(BUILD_EXECUTABLE)

#########################

include $(CLEAR_VARS)
LOCAL_SRC_FILES :=  mDNSPosix/PosixDaemon.c    \
                    mDNSPosix/mDNSPosix.c      \
                    mDNSPosix/mDNSUNP.c        \
                    mDNSCore/mDNS.c            \
                    mDNSCore/DNSDigest.c       \
                    mDNSCore/uDNS.c            \
                    mDNSCore/DNSCommon.c       \
                    mDNSShared/uds_daemon.c    \
                    mDNSShared/mDNSDebug.c     \
                    mDNSShared/dnssd_ipc.c     \
                    mDNSShared/GenLinkedList.c \
                    mDNSShared/PlatformCommon.c

LOCAL_MODULE := mdnsd
LOCAL_MODULE_TAGS := optional

LOCAL_C_INCLUDES := external/mdnsresponder/mDNSPosix \
                    external/mdnsresponder/mDNSCore  \
                    external/mdnsresponder/mDNSShared

LOCAL_CFLAGS := $(commonFlags) -DMDNS_USERNAME=\"mdnsr\" -DPLATFORM_NO_RLIMIT
LOCAL_STATIC_LIBRARIES := libc $(commonLibs)
LOCAL_FORCE_STATIC_EXECUTABLE := true
include $(BUILD_EXECUTABLE)
