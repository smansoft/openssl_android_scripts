# openssl_android_scripts
Scripts for build of the openssl lib (for Android x86, x86_6, armeabi-v7a, arm64-v8a).


### Windows x86_64 (windows-x86_64/):

openssl-1.1.1i:

        http://smansoft.com/openssl_android_scripts/windows-x86_64/openssl-1.1.1i.android.zip

1. Install Cygwin (including perl, make, gcc for cygwin):

    Cygwin:

        https://sourceforge.net/projects/mingw-w64/

2. Add path to Cygwin bin:

        C:\cygwin64
        C:\cygwin64\bin
        C:\cygwin64\sbin
        C:\cygwin64\usr\sbin
        C:\cygwin64\usr\local\bin

3. Unpack/install Android.ndk;
    for example:

        D:/sman/sdk/android/android-sdk.cur/ndk-bundle

4. Add Environment Variable ANDROID_NDK_HOME:

        ANDROID_NDK_HOME="d:/sman/sdk/android/android-ndk-r21d"

5. Add to the top of path:

        %ANDROID_NDK_HOME%\toolchains\llvm\prebuilt\windows-x86_64\bin

6. Add to the top of path:

        %ANDROID_NDK_HOME%/prebuilt\windows-x86_64\bin

7. Go to unpacked archive;

8. create in unpacked directory (OPENSSL sources direcroty) new subdirectory: _build;

9. cd ./_build;

    Note:   You can create directory _build somewhere or use some other directory for build.
        Just you need setup variables in the script: _build_openssl.sh.

10. copy file: _build_openssl.sh here;

11. setup in _build_openssl.sh 

        export API_LEVEL=23

12. setup in _build_openssl.sh 

        BUILD_TARGETS="armeabi-v7a arm64-v8a x86 x86_64";

    i.e. remove unnecessary or add some other platforms;

13. run:

        bash ./_build_openssl.sh

14. built libs and includes will be copied to:

        ./libs/arm64-v8a
        ./libs/armeabi-v7a
        ./libs/x86
        ./libs/x86_64 

        ./include

Note:
1. This archive contains changed files:

        Configurations/15-android.conf;
        
        Configure (build of apps is disabled, only build of static libs (.a) is provided);

2. All paths (in script) should contains only "/" instead "\", i.e.:

        D:/sman/sdk/android/android-sdk.cur/ndk-bundle

3. Path in ANDROID_NDK_HOME should contains only "/" instead "\" too.

4. "\" can be used only in PATH:

        %ANDROID_NDK_HOME%\toolchains\llvm\prebuilt\windows-x86_64\bin
        %ANDROID_NDK_HOME%\prebuilt\windows-x86_64\bin
        as operation system (Windows) requires "\";

5.
    open file

        Configurations\15-android.conf

    and update:

    this:

            # see if there is NDK clang on $PATH, "universal" or "standalone"
            if (which("clang") =~ m|^$ndk/.*/prebuilt/([^/]+)/|) {
                my $host=$1;
                # harmonize with gcc default
                my $arm = $ndkver > 16 ? "armv7a" : "armv5te";
                (my $tridefault = $triarch) =~ s/^arm-/$arm-/;
                (my $tritools   = $triarch) =~ s/(?:x|i6)86(_64)?-.*/x86$1/;
                $cflags .= " -target $tridefault "
                        .  "-gcc-toolchain \$($ndk_var)/toolchains"
                        .  "/$tritools-4.9/prebuilt/$host";
                $user{CC} = "clang" if ($user{CC} !~ m|clang|);
                $user{CROSS_COMPILE} = undef;
                if (which("llvm-ar") =~ m|^$ndk/.*/prebuilt/([^/]+)/|) {
                    $user{AR} = "llvm-ar";
                    $user{ARFLAGS} = [ "rs" ];
                    $user{RANLIB} = ":";
                }
            } elsif (-f "$ndk/AndroidVersion.txt") {    #"standalone toolchain"
                my $cc = $user{CC} // "clang";
                # One can probably argue that both clang and gcc should be
                # probed, but support for "standalone toolchain" was added
                # *after* announcement that gcc is being phased out, so
                # favouring clang is considered adequate. Those who insist
                # have option to enforce test for gcc with CC=gcc.
                if (which("$triarch-$cc") !~ m|^$ndk|) {
                    die "no NDK $triarch-$cc on \$PATH";
                }
                $user{CC} = $cc;
                $user{CROSS_COMPILE} = "$triarch-";
            } elsif ($user{CC} eq "clang") {
                die "no NDK clang on \$PATH";
            } else {
                if (which("$triarch-gcc") !~ m|^$ndk/.*/prebuilt/([^/]+)/|) {
                    die "no NDK $triarch-gcc on \$PATH";
                }
                $cflags .= " -mandroid";
                $user{CROSS_COMPILE} = "$triarch-";
            }

	to:

                my $host=$1;
                # harmonize with gcc default
                my $arm = $ndkver > 16 ? "armv7a" : "armv5te";
                (my $tridefault = $triarch) =~ s/^arm-/$arm-/;
                (my $tritools   = $triarch) =~ s/(?:x|i6)86(_64)?-.*/x86$1/;
                $cflags .= " -target $tridefault "
                        .  "-gcc-toolchain \$($ndk_var)/toolchains"
                        .  "/$tritools-4.9/prebuilt/$host";
                $user{CC} = "clang" if ($user{CC} !~ m|clang|);
                $user{CROSS_COMPILE} = undef;
                if (which("llvm-ar") =~ m|^$ndk/.*/prebuilt/([^/]+)/|) {
                    $user{AR} = "llvm-ar";
                    $user{ARFLAGS} = [ "rs" ];
                    $user{RANLIB} = ":";
                }

    i.e.
                should  be  executed  code,  that "clang" is found (as
                'clang' is used instead 'gcc');

6.
    open file (perl script)

    Configure

    and update:

    this:

        $config{dirs} = [ "crypto", "ssl", "engines", "apps", "test", "util", "tools", "fuzz" ];

    to:

        $config{dirs} = [ "crypto", "ssl", "engines" ];

    i.e.  build  of apps and other modules should be excepted (only static libs .a);


### Linux (linux-x86_64/):

openssl-1.1.1i:

        http://smansoft.com/openssl_android_scripts/linux-x86_64/openssl-1.1.1i.android.tar.gz

1. Add Environment Variables ANDROID_NDK_HOME and ANDROID_SDK_HOME:

        export ANDROID_SDK_HOME=/home/strgs/sdb.07/sman/sdk/android/android-sdk.cur
        export ANDROID_NDK_HOME=/home/strgs/sdb.07/sman/sdk/android/android-ndk-r21d

2. Add follow path to $PATH Environment Variable:

        export PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin:${PATH};

3. Go to unpacked archive;

4. Open file (perl script) "Configure"

    and update this line:

        $config{dirs} = [ "crypto", "ssl", "engines", "apps", "test", "util", "tools", "fuzz" ];
    
    to:

        $config{dirs} = [ "crypto", "ssl", "engines" ];

    i.e.  build  of apps and other modules should be excepted (only static libs .a);

5. Create in unpacked directory (OPENSSL sources direcroty) new subdirectory: _build;

6. cd ./_build;

    Note:   You can create directory _build somewhere or use some other directory for build.
        Just you need setup variables in the script: _build_openssl.sh.

7. copy file: _build_openssl.sh here;

8. setup in _build_openssl.sh
    
        export API_LEVEL=23;

9. setup in _build_openssl.sh 
    
        BUILD_TARGETS="armeabi-v7a arm64-v8a x86 x86_64";

    i.e. remove unnecessary or add some other platforms;

10. run:
        
        bash ./_build_openssl.sh

11. built libs and includes will be copied to:

        ./libs/arm64-v8a
        ./libs/armeabi-v7a
        ./libs/x86
        ./libs/x86_64

        ./include
