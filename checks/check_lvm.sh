#!/usr/bin/env bash

# Check LVM Data and Metadata usage

WARN_PERC=${1-80}
CRIT_PERC=${2-90}

function compare_decimal() {
    local RES=$(echo "$1 $2" | awk '{print ($1 > $2)}')
    echo "$RES"
}

EXIT=0

IFS='
'
for R in $(lvs --noheadings --separator ' ' -o lv_name,data_percent,metadata_percent); do
    LV_NAME=$(echo $R | awk '{ if ( $1!="" ) { print $1 } else { print "0"} }')
    DATA_PERC=$(echo $R | awk '{ if ( $2!="" ) { print $2 } else { print "0"} }')
    META_PERC=$(echo $R | awk '{ if ( $3!="" ) { print $3 } else { print "0"} }')

   [ "$(compare_decimal $META_PERC $CRIT_PERC)" == 1 ] && echo "Critical: $LV_NAME metadata usage ${DATA_PERC}%" && EXIT=$((EXIT + 2)) && continue
   [ "$(compare_decimal $META_PERC $WARN_PERC)" == 1 ] && echo "Warning: $LV_NAME metadata usage ${DATA_PERC}%" && EXIT=$((EXIT + 1)) && continue

   [ "$(compare_decimal $DATA_PERC $CRIT_PERC)" == 1 ] && echo "Critical: $LV_NAME data usage ${DATA_PERC}%" && EXIT=$((EXIT + 2)) && continue
   [ "$(compare_decimal $DATA_PERC $WARN_PERC)" == 1 ] && echo "Warning: $LV_NAME data usage ${DATA_PERC}%" && EXIT=$((EXIT + 1)) && continue

done

exit $EXIT
