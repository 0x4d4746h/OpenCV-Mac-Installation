# OpenCV-Mac-Installation
How to install and split OpenCV dylib to the single project

# 官网下载OpenCV源码： http://opencv.org
# 编译安装到Mac平台，执行以下命令：
<pre>
#!/bin/bash
mkdir build
cd build
cmake -G "Unix Makefiles" ..
make j8
sudo make install
</pre>
* 到此OpenCV成功安装到Mac平台，现在可以基于OpenCV库来进行开发。 
* 以OpenCV_2.4.10 版本为例, 在代码中通过System.load()加载的OpenCV动态库为libopencv_java2410.dylib, 
获取路径为/usr/local/share/OpenCV/java/, 可以copy到工程路径中去
* 开发完成之后对于用Java开发而言要打包成runnable jar 包，还需要把OpenCV(libopencv_java2410.dylib)依赖的相关动态库取出来放到jar包里去，具体操作如下:
打开/usr/local/share/OpenCV/java/, 运行命令：
<pre>otool -L libopencv_java2410.dylib</pre>
  结果输出：
<pre>
libopencv_java2410.dylib:
	lib/libopencv_java2410.dylib (compatibility version 0.0.0, current version 0.0.0)
	lib/libopencv_contrib.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	lib/libopencv_nonfree.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	lib/libopencv_gpu.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	lib/libopencv_legacy.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	lib/libopencv_photo.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	lib/libopencv_ocl.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	lib/libopencv_calib3d.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	lib/libopencv_features2d.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	lib/libopencv_flann.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	lib/libopencv_ml.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	lib/libopencv_video.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	lib/libopencv_objdetect.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	lib/libopencv_highgui.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	lib/libopencv_imgproc.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	lib/libopencv_core.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 120.0.0)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1213.0.0)
</pre>
然后打开/usr/local/lib, copy出libopencv_*.dylib的实体dylib文件(非软连接文件)到 runnable jar包应用中的某一个路径文件夹中， 并把文件名称改成与步骤a)结果输出中一致
 然后运行如下Shell脚本：
<pre>
CV_LIB_PATH=/Applications/iTestin.app/Contents/Jar/tools/OpenCV/mac/dylib
find ${CV_LIB_PATH} -type f -name "libopencv*.dylib" -print0 | while IFS="" read -r -d "" dylibpath; do
   install_name_tool -id "$dylibpath" "$dylibpath"
   otool -L $dylibpath | grep libopencv | tr -d ':' | while read -a libs ; do
       [ "${file}" != "${libs[0]}" ] && install_name_tool -change ${libs[0]} ${CV_LIB_PATH}/`basename ${libs[0]}` $dylibpath
   done
done
</pre>
执行完成之后进入到工具路径下，执行otool -L *查看相关动态库的链接路径是否改变(以libopencv_calib3d.2.4.dylib为例)：
<pre>
libopencv_calib3d.2.4.dylib:
	lib/libopencv_calib3d.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	/Applications/iTestin.app/Contents/Jar/tools/OpenCV/mac/dylib/libopencv_features2d.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	/Applications/iTestin.app/Contents/Jar/tools/OpenCV/mac/dylib/libopencv_flann.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	/Applications/iTestin.app/Contents/Jar/tools/OpenCV/mac/dylib/libopencv_highgui.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	/Applications/iTestin.app/Contents/Jar/tools/OpenCV/mac/dylib/libopencv_imgproc.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	/Applications/iTestin.app/Contents/Jar/tools/OpenCV/mac/dylib/libopencv_core.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 120.0.0)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1213.0.0)
</pre>
* 最后再次执行命令 otool -L libopencv_java2410.dylib， 查看路径是否改变： 输出结果：
<pre>
libopencv_java2410.dylib:
	lib/libopencv_java2410.dylib (compatibility version 0.0.0, current version 0.0.0)
	@loader_path/dylib/libopencv_contrib.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	@loader_path/dylib/libopencv_nonfree.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	@loader_path/dylib/libopencv_gpu.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	@loader_path/dylib/libopencv_legacy.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	@loader_path/dylib/libopencv_photo.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	@loader_path/dylib/libopencv_ocl.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	@loader_path/dylib/libopencv_calib3d.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	@loader_path/dylib/libopencv_features2d.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	@loader_path/dylib/libopencv_flann.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	@loader_path/dylib/libopencv_ml.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	@loader_path/dylib/libopencv_video.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	@loader_path/dylib/libopencv_objdetect.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	@loader_path/dylib/libopencv_highgui.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	@loader_path/dylib/libopencv_imgproc.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	@loader_path/dylib/libopencv_core.2.4.dylib (compatibility version 2.4.0, current version 2.4.10)
	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 120.0.0)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1213.0.0)
</pre>
全部更改完成，到此导出的包可以在生产环境的Mac机器上运行
