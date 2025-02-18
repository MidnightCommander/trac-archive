%undefine _disable_source_fetch

Name: mc
Version: 4.8.20
Release: 3
License: GNU General Public License, Version 3
Summary: Midnight Commander
Url: https://midnight-commander.org/

Source0: https://github.com/MidnightCommander/mc/archive/%{version}.tar.gz
Patch0: mc_configure.ac.patch
Patch1: mc_common.c.patch

BuildRequires: boost
BuildRequires: libxml2-devel
BuildRequires: libxml2-2
BuildRequires: libxml2-tools
BuildRequires: bison
BuildRequires: pcre-devel
BuildRequires: pkg-config
BuildRequires: unixODBC-devel
BuildRequires: curl-devel
BuildRequires: openssl-devel < 1.1.0
BuildRequires: libxslt-devel
BuildRequires: autoconf
BuildRequires: automake
BuildRequires: m4-gnu
BuildRequires: gettext-tools
BuildRequires: gettext-runtime
BuildRequires: libtool
BuildRequires: libutil-devel
BuildRequires: glib2-devel
BuildRequires: slang-devel
BuildRequires: /QOpenSys/pkgs/bin/sed
BuildRequires: /QOpenSys/pkgs/bin/perl

%description
GNU Midnight Commander is a visual file manager, licensed under GNU General Public License and therefore qualifies as Free Software. It's a feature rich full-screen text mode application that allows you to copy, move and delete files and whole directory trees, search for files and run commands in the subshell. Internal viewer and editor are included. 

%prep
%setup
echo about to apply patches
%patch0 -p1
%patch1 -p1
echo about to hack configure.ac with sed
/QOpenSys/pkgs/bin/sed -i 's|\/usr\/bin\/python|\/QOpenSys\/pkgs\/bin\/python2|g' configure.ac
/QOpenSys/pkgs/bin/sed -i 's|\/usr\/bin\/ruby|\/QOpenSys\/pkgs\/bin\/ruby|g' configure.ac
/QOpenSys/pkgs/bin/sed -i 's|\/usr\/bin\/perl|\/QOpenSys\/pkgs\/bin\/perl|g' configure.ac

%build

./autogen.sh

%configure    \
    LDFLAGS="-lpthread -Wl,-bbigtoc -Wl,-brtl -Wl,-lpthread,-lutil -Wl,-blibpath:/QOpenSys/pkgs/lib:/QOpenSys/usr/lib:/usr/lib" \
    CPPFLAGS="$CPPFLAGS -I%{_includedir} -Wl,-lpthread -Wl,-blibpath:/QOpenSys/pkgs/lib:/QOpenSys/usr/lib:/usr/lib -DHAVE_CLOCK_GETTIME"  \
    CFLAGS="$CFLAGS -I%{_includedir} -Wl,-lpthread -Wl,-blibpath:/QOpenSys/pkgs/lib:/QOpenSys/usr/lib:/usr/lib -DHAVE_CLOCK_GETTIME" \
    --build=powerpc64-ibm-os400  \
    --host=powerpc64-ibm-os400  \
    --with-ncurses-libs=/QOpenSys/pkgs/lib \
    --enable-shared=yes \ 
    #end

ls -l  
%make_build -j1 


%install

%make_install INSTALL_ROOT=$RPM_BUILD_ROOT

%files
%defattr(-, qsys, *none)
%{_bindir}/mc*
%{_libexecdir}/mc
%{_sysconfdir}/mc
%{_datadir}/mc
%{_mandir}/man1/mc*
%{_mandir}/es/man1/mc.1
%{_mandir}/hu/man1/mc.1
%{_mandir}/it/man1/mc.1
%{_mandir}/pl/man1/mc.1
%{_mandir}/ru/man1/mc.1
%{_mandir}/sr/man1/mc.1
%{_datadir}/locale/az/LC_MESSAGES/mc.mo
%{_datadir}/locale/be/LC_MESSAGES/mc.mo
%{_datadir}/locale/bg/LC_MESSAGES/mc.mo
%{_datadir}/locale/ca/LC_MESSAGES/mc.mo
%{_datadir}/locale/cs/LC_MESSAGES/mc.mo
%{_datadir}/locale/da/LC_MESSAGES/mc.mo
%{_datadir}/locale/de/LC_MESSAGES/mc.mo
%{_datadir}/locale/de_CH/LC_MESSAGES/mc.mo
%{_datadir}/locale/el/LC_MESSAGES/mc.mo
%{_datadir}/locale/en_GB/LC_MESSAGES/mc.mo
%{_datadir}/locale/eo/LC_MESSAGES/mc.mo
%{_datadir}/locale/es/LC_MESSAGES/mc.mo
%{_datadir}/locale/et/LC_MESSAGES/mc.mo
%{_datadir}/locale/eu/LC_MESSAGES/mc.mo
%{_datadir}/locale/fa/LC_MESSAGES/mc.mo
%{_datadir}/locale/fi/LC_MESSAGES/mc.mo
%{_datadir}/locale/fr/LC_MESSAGES/mc.mo
%{_datadir}/locale/fr_CA/LC_MESSAGES/mc.mo
%{_datadir}/locale/gl/LC_MESSAGES/mc.mo
%{_datadir}/locale/hr/LC_MESSAGES/mc.mo
%{_datadir}/locale/hu/LC_MESSAGES/mc.mo
%{_datadir}/locale/ia/LC_MESSAGES/mc.mo
%{_datadir}/locale/id/LC_MESSAGES/mc.mo
%{_datadir}/locale/it/LC_MESSAGES/mc.mo
%{_datadir}/locale/ja/LC_MESSAGES/mc.mo
%{_datadir}/locale/ka/LC_MESSAGES/mc.mo
%{_datadir}/locale/kk/LC_MESSAGES/mc.mo
%{_datadir}/locale/ko/LC_MESSAGES/mc.mo
%{_datadir}/locale/lt/LC_MESSAGES/mc.mo
%{_datadir}/locale/lv/LC_MESSAGES/mc.mo
%{_datadir}/locale/mn/LC_MESSAGES/mc.mo
%{_datadir}/locale/nb/LC_MESSAGES/mc.mo
%{_datadir}/locale/nl/LC_MESSAGES/mc.mo
%{_datadir}/locale/pl/LC_MESSAGES/mc.mo
%{_datadir}/locale/pt/LC_MESSAGES/mc.mo
%{_datadir}/locale/pt_BR/LC_MESSAGES/mc.mo
%{_datadir}/locale/ro/LC_MESSAGES/mc.mo
%{_datadir}/locale/ru/LC_MESSAGES/mc.mo
%{_datadir}/locale/sk/LC_MESSAGES/mc.mo
%{_datadir}/locale/sl/LC_MESSAGES/mc.mo
%{_datadir}/locale/sr/LC_MESSAGES/mc.mo
%{_datadir}/locale/sv/LC_MESSAGES/mc.mo
%{_datadir}/locale/szl/LC_MESSAGES/mc.mo
%{_datadir}/locale/ta/LC_MESSAGES/mc.mo
%{_datadir}/locale/te/LC_MESSAGES/mc.mo
%{_datadir}/locale/tr/LC_MESSAGES/mc.mo
%{_datadir}/locale/uk/LC_MESSAGES/mc.mo
%{_datadir}/locale/vi/LC_MESSAGES/mc.mo
%{_datadir}/locale/wa/LC_MESSAGES/mc.mo
%{_datadir}/locale/zh_CN/LC_MESSAGES/mc.mo
%{_datadir}/locale/zh_TW/LC_MESSAGES/mc.mo


%changelog
