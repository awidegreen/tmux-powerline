# prints the bitcoins exchange rate, from blockchain.info
# configure the currecy by TMUX_POWERLINE_BTC_X_RATE_CURRENCY
# possible currency value: see https://blockchain.info/ticker
# 
# author github @awidegreen

run_segment() {
  local tmp_file="${TMUX_POWERLINE_DIR_TEMPORARY}/btc_x_rate.txt"
  local btc_x_rate
  local bcexrate="${TMUX_POWERLINE_DIR_LIB}/bcexrate.rb"

  if [ -f "$tmp_file" ]; then
    if shell_is_osx || shell_is_bsd; then
      stat >/dev/null 2>&1 && is_gnu_stat=false || is_gnu_stat=true
      if [ "$is_gnu_stat" == "true" ];then
        last_update=$(stat -c "%Y" ${tmp_file})
      else
        last_update=$(stat -f "%m" ${tmp_file})
      fi
    elif shell_is_linux || [ -z $is_gnu_stat]; then
      last_update=$(stat -c "%Y" ${tmp_file})
    fi

    time_now=$(date +%s)
    update_period=900 # 15 minutes
    up_to_date=$(echo "(${time_now}-${last_update}) < ${update_period}" | bc)

    if [ "$up_to_date" -eq 1 ]; then
      btc_x_rate=$(cat ${tmp_file})
    fi
  fi

  if [ -z "$btc_x_rate" ]; then
    btc_x_rate=$($bcexrate $TMUX_POWERLINE_BTC_X_RATE_CURRENCY)

    if [ "$?" -eq "0" ]; then
      echo "${btc_x_rate}" > $tmp_file
    elif [ -f "${tmp_file}" ]; then
      btc_x_rate=$(cat "$tmp_file")
    fi
  fi

  if [ -n "$btc_x_rate" ]; then
    echo "${btc_x_rate}"
  fi

  return 0
}
