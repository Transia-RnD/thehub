#!/bin/bash
# ./build_rippled.sh -genesis -docker "transia" -github "https://github.com/XRPLF/rippled.git" -branch "amm"
# docker build --platform=linux/x86_64 --tag transia/xrpld-standalone:latest . && docker create transia/xrpld-standalone
# docker push transia/xrpld-standalone:latest

# docker build --platform=linux/x86_64 --tag transia/paychan-escrow:alone . --build-arg BOOST_ROOT=/io/boost_1_75_0 --build-arg Boost_LIBRARY_DIRS=/io/boost_1_75_0/libs --build-arg BOOST_INCLUDEDIR=/io/boost_1_75_0/boost

declare -A flags
declare -A booleans
args=()

while [ "$1" ];
do
    arg=$1
    if [ "${1:0:1}" == "-" ]
    then
      shift
      rev=$(echo "$arg" | rev)
      if [ -z "$1" ] || [ "${1:0:1}" == "-" ] || [ "${rev:0:1}" == ":" ]
      then
        bool=$(echo ${arg:1} | sed s/://g)
        booleans[$bool]=true
        echo \"$bool\" is boolean
      else
        value=$1
        flags[${arg:1}]=$value
        shift
        echo \"$arg\" is flag with value \"$value\"
      fi
    else
      args+=("$arg")
      shift
      echo \"$arg\" is an arg
    fi
done


echo -e "\n"
echo booleans: ${booleans[@]}
echo flags: ${flags[@]}
echo args: ${args[@]}

echo -e "\nBoolean types:\n\tPrecedes Flag(pf): ${booleans[pf]}\n\tFinal Arg(f): ${booleans[f]}\n\tColon Terminated(Ct): ${booleans[Ct]}\n\tNot Mentioned(nm): ${boolean[nm]}"
echo -e "\nFlag: myFlag => ${flags["myFlag"]}"
echo -e "\nArgs: one: ${args[0]}, two: ${args[1]}, three: ${args[2]}"


# docker build --platform=linux/x86_64 --tag transia/xrpld-standalone:latest . && docker create transia/xrpld-standalone
# docker push transia/xrpld-standalone:latest