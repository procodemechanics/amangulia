#ifndef SENSING_H_
#define SENSING_H_

enum {
  AM_SENSING_REPORT = -1
};

nx_struct sensing_report {
  nx_uint16_t seqno;
  nx_uint16_t sender;
  nx_uint16_t instrument;
} ;

typedef nx_struct settings {
  nx_uint16_t light_threshold;
  nx_uint16_t instrument;
} settings_t;

#define REPORT_DEST "fec0::100"
#define MULTICAST "ff02::1"

#endif
