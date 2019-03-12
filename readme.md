HW02
===
This is the hw02 sample. Please follow the steps below.

# Build the Sample Program

1. Fork this repo to your own github account.

2. Clone the repo that you just forked.

3. Under the hw02 dir, use:

	* `make` to build.

	* `make clean` to clean the ouput files.

4. Extract `gnu-mcu-eclipse-qemu.zip` into hw02 dir. Under the path of hw02, start emulation with `make qemu`.

	See [Lecture 02 ─ Emulation with QEMU] for more details.

5. The sample is designed to help you to distinguish the main difference between the `b` and the `bl` instructions.  

	See [ESEmbedded_HW02_Example] for knowing how to do the observation and how to use markdown for taking notes.

# Build Your Own Program

1. Edit main.s.

2. Make and run like the steps above.

# HW02 Requirements

1. Please modify main.s to observe the `push` and the `pop` instructions:  

	Does the order of the registers in the `push` and the `pop` instructions affect the excution results?  

	For example, will `push {r0, r1, r2}` and `push {r2, r0, r1}` act in the same way?  

	Which register will be pushed into the stack first?

2. You have to state how you designed the observation (code), and how you performed it.  

	Just like how [ESEmbedded_HW02_Example] did.

3. If there are any official data that define the rules, you can also use them as references.

4. Push your repo to your github. (Use .gitignore to exclude the output files like object files or executable files and the qemu bin folder)

[Lecture 02 ─ Emulation with QEMU]: http://www.nc.es.ncku.edu.tw/course/embedded/02/#Emulation-with-QEMU
[ESEmbedded_HW02_Example]: https://github.com/vwxyzjimmy/ESEmbedded_HW02_Example

--------------------

- [ ] **If you volunteer to give the presentation next week, check this.**

--------------------

# ESEmbedded_HW02

## Environment

OS
```bash=
NAME="Ubuntu"
VERSION="16.04.6 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.6 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial
```
    
gcc
```bash=
Using built-in specs.
COLLECT_GCC=arm-none-eabi-gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/arm-none-eabi/4.9.3/lto-wrapper
Target: arm-none-eabi
Configured with: ../src/configure --build=x86_64-linux-gnu --prefix=/usr --includedir='/usr/lib/include' --mandir='/usr/lib/share/man' --infodir='/usr/lib/share/info' --sysconfdir=/etc --localstatedir=/var --disable-silent-rules --libdir='/usr/lib/lib/x86_64-linux-gnu' --libexecdir='/usr/lib/lib/x86_64-linux-gnu' --disable-maintainer-mode --disable-dependency-tracking --mandir=/usr/share/man --enable-languages=c,c++,lto --enable-multilib --disable-decimal-float --disable-libffi --disable-libgomp --disable-libmudflap --disable-libquadmath --disable-libssp --disable-libstdcxx-pch --disable-nls --disable-shared --disable-threads --disable-tls --build=x86_64-linux-gnu --target=arm-none-eabi --with-system-zlib --with-gnu-as --with-gnu-ld --with-pkgversion=15:4.9.3+svn231177-1 --without-included-gettext --prefix=/usr/lib --infodir=/usr/share/doc/gcc-arm-none-eabi/info --htmldir=/usr/share/doc/gcc-arm-none-eabi/html --pdfdir=/usr/share/doc/gcc-arm-none-eabi/pdf --bindir=/usr/bin --libexecdir=/usr/lib --libdir=/usr/lib --disable-libstdc++-v3 --host=x86_64-linux-gnu --with-headers=no --without-newlib --with-multilib-list=armv6-m,armv7-m,armv7e-m,armv7-r CFLAGS='-g -O2 -fstack-protector-strong' CPPFLAGS=-D_FORTIFY_SOURCE=2 CXXFLAGS='-g -O2 -fstack-protector-strong' FCFLAGS='-g -O2 -fstack-protector-strong' FFLAGS='-g -O2 -fstack-protector-strong' GCJFLAGS='-g -O2 -fstack-protector-strong' LDFLAGS='-Wl,-Bsymbolic-functions -Wl,-z,relro' OBJCFLAGS='-g -O2 -fstack-protector-strong' OBJCXXFLAGS='-g -O2 -fstack-protector-strong' INHIBIT_LIBC_CFLAGS=-DUSE_TM_CLONE_REGISTRY=0 AR_FOR_TARGET=arm-none-eabi-ar AS_FOR_TARGET=arm-none-eabi-as LD_FOR_TARGET=arm-none-eabi-ld NM_FOR_TARGET=arm-none-eabi-nm OBJDUMP_FOR_TARGET=arm-none-eabi-objdump RANLIB_FOR_TARGET=arm-none-eabi-ranlib READELF_FOR_TARGET=arm-none-eabi-readelf STRIP_FOR_TARGET=arm-none-eabi-strip
Thread model: single
gcc version 4.9.3 20150529 (prerelease) (15:4.9.3+svn231177-1)
```

## Questions
1. Please modify main.s to observe the `push` and the `pop` instructions:  

	Does the order of the registers in the `push` and the `pop` instructions affect the excution results?  

	For example, will `push {r0, r1, r2}` and `push {r2, r0, r1}` act in the same way?  

	Which register will be pushed into the stack first?

2. You have to state how you designed the observation (code), and how you performed it.

## Answers

* Find `PUSH` and `POP` in manual
    * PUSH
        * ![](https://i.imgur.com/jrKcN9i.png)
    * POP
        * ![](https://i.imgur.com/hsiY6dj.png)


* Observe the value of `SP` and other reg

    *   ```
        SP, the Stack Pointer

        Register R13 is used as a pointer to the active stack.
        ```
    
    * modify main.s
        * ```clike=
            .syntax unified

            .word 0x20000100
            .word _start

            .global _start
            .type _start, %function
            _start:
                mov r0, #0
                mov r1, #1
                mov r2, #2

                // normal
                push {r0,r1,r2}
                pop {r3,r4,r5}

                // change push order
                push {r1,r0,r2}
                pop {r3,r4,r5}

                // change pop order
                push {r0,r1,r2}
                pop {r4,r3,r5}

                // change both push and pop order
                push {r1,r0,r2}
                pop {r4,r3,r5}

                // push step by step
                push {r1}
                push {r0}
                push {r2}
                pop {r3,r4,r5}
            ```
        * asign 0,1,2 to \$r0,\$r1,\$r2
        ![](https://i.imgur.com/q0jHMo5.png)

        * change the order of `push` and `pop`

    * Result
      ```clike=
      // normal
      push {r0,r1,r2}
      pop {r3,r4,r5}
      ```
        * push
        ![](https://i.imgur.com/NLveEpi.png)
            * after `push` `$SP` from 0x20000100 to 0x200000f4
            * cause one reg is 32 bits (4 bytes)
            * 0x0100 to 0x00f4 is 12 bytes
            * we push 3 reg so it needs 12 bytes 
        * pop  
        ![](https://i.imgur.com/YFH6yUH.png)


      ```clike=
      // change push order
      push {r1,r0,r2}
      pop {r3,r4,r5}
      ```
        * push
        ![](https://i.imgur.com/36yJP8g.png)
        * pop  
        ![](https://i.imgur.com/ROupcHq.png)

      ```clike=
      // change pop order
      push {r0,r1,r2}
      pop {r4,r3,r5}
      ```
        * push
        ![](https://i.imgur.com/VfP9wIU.png)
        * pop  
        ![](https://i.imgur.com/0n6K3fz.png)
        
      ```clike=
      // change both push and pop order
      push {r1,r0,r2}
      pop {r4,r3,r5}
      ```
        * push
        ![](https://i.imgur.com/21iXx5y.png)
        * pop  
        ![](https://i.imgur.com/e8IgYr3.png)

      ```clike=
      push step by step
      push {r1}
      push {r0}
      push {r2}
      pop {r3,r4,r5}
      ```
        * push
        ![](https://i.imgur.com/guGcLOk.png)
        * pop  
        ![](https://i.imgur.com/oSBqNMJ.png)
        
    * Conclusion
    Change order won't change the result
    In `ARM Architecture Reference Manual Thumb-2 Supplement P296`
    ```
    Is a list of one or more registers, separated by commas and surrounded by { and }. It
    specifies the set of registers to be stored. The registers are stored in sequence, the
    lowest-numbered register to the lowest memory address, through to the highest-numbered
    register to the highest memory address
    ```
