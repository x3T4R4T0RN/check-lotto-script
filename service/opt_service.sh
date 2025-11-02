#!/bin/bash

FLAG_SUMMARY=true
FLAG_FIND=false

# -------------------------------
# Function: mapopt
# -------------------------------
# - Map operation function
# - Output: Feature flag
# -------------------------------
mapopt() {
  while getopts "f:sh" opt; do
    case $opt in
      f)
        FLAG_SUMMARY=false
        FLAG_FIND=true
        ;;
      s)
        FLAG_SUMMARY=true
        FLAG_FIND=false
        ;;
      h)
        echo "Usage:"
        echo "  -s            แสดงสรุปผลรางวัลล่าสุด"
        echo "  -f <numbers>  ตรวจหมายเลข (ใส่ได้หลายเลข)"
        exit 0
        ;;
      *)
        FLAG_SUMMARY=true
        FLAG_FIND=false
        ;;
    esac
  done
}
