%define ruby_sitelib %(ruby -rrbconfig -e "puts Config::CONFIG['sitelibdir']")
%define release %{rpm_release}%{?dist}

Summary: EC2 Bootstrap System
Name: ec2-boot-init
Version: %{version}
Release: %{release}
Group: System Tools
License: Apache License, Version 2
URL: http://www.devco.net/
Source0: %{name}-%{version}.tgz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
Requires: ruby
Packager: R.I.Pienaar <rip@devco.net>
BuildArch: noarch

%description
Bootstrap system for EC2 based systems.

%prep
%setup -q

%build

%install
rm -rf %{buildroot}
%{__install} -d -m0755  %{buildroot}/%{ruby_sitelib}/ec2boot
%{__install} -d -m0755  %{buildroot}/usr/sbin
%{__install} -d -m0755  %{buildroot}/etc/init.d
%{__install} -d -m0755  %{buildroot}/etc/ec2-boot-init
%{__install} -d -m0755  %{buildroot}/etc/ec2-boot-init/actions
%{__install} -m0755 ec2-boot-init.rb %{buildroot}/usr/sbin/ec2-boot-init
%{__install} -m0755 ec2-boot-init.init %{buildroot}/etc/init.d/ec2-boot-init
%{__install} -m0644 motd.provisioned %{buildroot}/etc/ec2-boot-init/motd.provisioned
%{__install} -m0644 motd.unprovisioned %{buildroot}/etc/ec2-boot-init/motd.unprovisioned


cp -R lib/* %{buildroot}/%{ruby_sitelib}/
cp -R actions/* %{buildroot}/etc/ec2-boot-init/actions/

%clean
rm -rf %{buildroot}

%post
cp /etc/ec2-boot-init/motd.unprovisioned /etc/motd
/sbin/chkconfig --add ec2-boot-init || :

%postun 
if [ "$1" -ge 1 ]; then
	/sbin/service ec2-boot-init condrestart &>/dev/null || :
fi

%preun 
if [ "$1" = 0 ] ; then
  /sbin/chkconfig --del ec2-boot-init || :
fi

%files
%doc COPYING
/usr/sbin/ec2-boot-init
/etc/ec2-boot-init
/etc/init.d/ec2-boot-init
%{ruby_sitelib}/ec2boot.rb
%{ruby_sitelib}/ec2boot

%changelog
* Tue Nov 03 2009 R.I.Pienaar <rip@devco.net> 
- First release
