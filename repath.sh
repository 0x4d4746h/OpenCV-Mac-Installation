CV_LIB_PATH=your/dylib/path

LOAD_LIB_PATH=@loader_path
find ${CV_LIB_PATH} -type f -name "libopencv*.dylib" -print0 | while IFS="" read -r -d "" dylibpath; do
   echo install_name_tool -id "$dylibpath" "$dylibpath"
   #install_name_tool -id "$dylibpath" "$dylibpath"
   otool -L $dylibpath | grep libopencv | tr -d ':' | while read -a libs ; do
   		#echo install_name_tool -change ${libs[0]} ${CV_LIB_PATH}/`basename ${libs[0]}` $dylibpath
       [ "${file}" != "${libs[0]}" ] && install_name_tool -change ${libs[0]} ${LOAD_LIB_PATH}/`basename ${libs[0]}` $dylibpath
   done
done