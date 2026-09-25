Name:       harbour-sailscq
Summary:    SailSCQ - control Soundcore headphones (based on OpenSCQ30)
Version:    0.14
Release:    1
License:    GPL-3.0-or-later
# TODO: replace with the address of your own SailSCQ source repository
URL:        https://github.com/Oppzippy/OpenSCQ30
Source0:    %{name}-%{version}.tar.bz2

# The bundled openscq30 CLI in bin/<arch>/ is a prebuilt binary. Only aarch64
# is included; to support more targets put a matching build into
# bin/armv7hl/ or bin/i486/ and add the architecture here.
ExclusiveArch: aarch64

Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   bluez5

# SailSCQ was called harbour-openscq30 before 0.11: replace it on install
Obsoletes:  harbour-openscq30 < 0.11
Provides:   harbour-openscq30 = %{version}-%{release}

BuildRequires:  pkgconfig(sailfishapp) >= 1.0.3
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5DBus)
BuildRequires:  desktop-file-utils

# Do not try to generate debuginfo for the prebuilt, stripped CLI
%define debug_package %{nil}

%description
SailSCQ is a Sailfish OS app to control Soundcore headphones, earbuds and
speakers: sound modes, noise canceling, equalizer, button configuration,
battery levels and more.

It is an unofficial user interface for the OpenSCQ30 command line tool
(https://github.com/Oppzippy/OpenSCQ30), which is bundled with the app.
Not affiliated with Anker or Soundcore.

%prep
%setup -q -n %{name}-%{version}

%build
%qmake5 VERSION=%{version} RELEASE=%{release}
%make_build

%install
%qmake5_install

install -D -m 755 bin/%{_target_cpu}/openscq30 \
    %{buildroot}%{_datadir}/%{name}/bin/openscq30

desktop-file-install --delete-original \
    --dir %{buildroot}%{_datadir}/applications \
    %{buildroot}%{_datadir}/applications/*.desktop

%post
# Let the home screen pick up the (changed) icon and desktop file
touch --no-create %{_datadir}/icons/hicolor >/dev/null 2>&1 || :
gtk-update-icon-cache -q %{_datadir}/icons/hicolor >/dev/null 2>&1 || :
update-desktop-database %{_datadir}/applications >/dev/null 2>&1 || :

%postun
touch --no-create %{_datadir}/icons/hicolor >/dev/null 2>&1 || :
gtk-update-icon-cache -q %{_datadir}/icons/hicolor >/dev/null 2>&1 || :
update-desktop-database %{_datadir}/applications >/dev/null 2>&1 || :

%files
%defattr(-,root,root,-)
%license LICENSE
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
