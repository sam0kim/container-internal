# container-internal
컨테이너 인터널 실습 리포입니다.  
> 맥/윈도우 x86기반 환경을 안내합니다. Mac M1, M2 arm 계열환경안내는 https://github.com/sam0kim/container-internal/tree/main/m1 를 참고해 주세요 

## 실습 환경 갖추기
### 실습 안내
- Mac/윈도우 환경에서 VirtualBox 와 Vagrant 기반으로 테스트 되었습니다  
- Mac 이외 OS 환경에서도 가급적 “Vagrant + VirtualBox” 사용을 권장드립니다.
> Vagrant 기반 실습환경 준비가 어려운 분들은 아래 "Vagrant 미지원 시 실습환경 갖추기"를 참고해주세요.

### 실습 도구 
- Virtualbox 공식 다운로드 및 설치 https://www.virtualbox.org/wiki/Downloads
- Vagrant 공식 다운로드 및 설치 https://www.vagrantup.com/downloads

맥 OS기준 (M1제외) Virtualbox 및 Vagrant 설치 방법은 다음과 같습니다.

설치 방법
```bash
# virtualbox 설치
brew install virtualbox --cask
# vagrant 설치
brew install vagrant --cask
```

Virtualbox 설정
- (설정1) 시스템 환경 설정에서 “Oracle” 허용 및 맥 재부팅
```
시스템 환경설정 > 보안 및 개인 정보 보호 > 일반 > 하단에 Oracle 관련 설치 허용
```
- (설정2) 네트워크 range 설정
  (참고) https://www.virtualbox.org/manual/ch06.html#network_hostonly
```bash
$ sudo -i
# mkdir -p /etc/vbox/
# vi /etc/vbox/networks.conf
* 0.0.0.0/0 ::/0
```
FAQ
1) VM기동(vagrant up) 중 에러 메시지1
```
...
VBoxManage: error: VBoxNetAdpCtl: Error while adding new interface: failed to open /dev/vboxnetctl: No such file or directory
...
```
Sol) 위의 Virtualbox (설정1)을 확인해 주세요

2) VM기동(vagrant up) 중 에러 메시지2
```
Valid ranges can be modified in the /etc/vbox/networks.conf file
```
Sol) 위의 Virtualbox (설정2)를 확인해 주세요

### 실습 환경
아래 Vagrantfile을 사용합니다.
- Mac/윈도우 Intel,x86계열 https://raw.githubusercontent.com/sam0kim/container-internal/main/Vagrantfile  

Vagrant 기본 사용법. vagrant는 "Vagrantfile" 경로를 기준으로 동작합니다.
```bash
# VM 중지와 재개
$ vagrant suspend
$ vagrant resume

# VM 종료와 기동
$ vagrant halt
$ vagrant up

# VM 재기동
$ vagrant reload

# VM 재설정/기동
$ vagrant reload --provision

# VM 상태 확인 (VM 목록별 상태 출력)
$ vagrant status

# VM 터미널 접속
$ vagrant ssh <VM이름>
```

### 실습 참고
- 실습 터미널 : VM 터미널 창을 두 개를 준비해주세요. (Vagrantfile 경로에서 실행)
```bash
vagrant ssh ubuntu1804
```
- 실습 계정 : root 계정을 기본으로 합니다.
```bash
vagrant@ubuntu1804:~$ sudo -Es
root@ubuntu1804:~#
```
- 실습 경로 : /tmp 를 기본으로 합니다.
```bash
root@ubuntu1804:~# cd /tmp
root@ubuntu1804:/tmp#
```
> Q. 실습경로를 제한하는 이유? 
> > virtualbox의 특수한 mount 경로 사용 시 심볼릭 링크 제한 등 실습이 원활하지 않을 수 있어 실습경로를 통일합니다.
- 실습 종료 : chroot, unshare, nsneter, docker exec 등 컨테이너 사용 시 각 실습이 끝나면 “exit” 로 컨테이너 프로세스를 종료해 주세요.
```bash
bash-4.4# exit
exit
root@ubuntu1804:/tmp#
```

## Vagrant 미지원 시 실습환경 갖추기
- 본 가이드는 Vagrant 기반 실습환경 구성이 어려운 경우에 해당합니다.
- Ubuntu(1804) 환경을 2개 준비해 주세요. * 무료클라우드 활용 등

### 실습 환경 갖추기 
각자 준비된 Ubuntu(1804) 환경에서 아래 설치 스크립트를 실행해 주세요
- Pre-requisite
```bash 
apt-get update \
&& apt-get -y install gcc \
&& apt-get -y install make \
&& apt-get -y install pkg-config \
&& apt-get -y install libseccomp-dev \
&& apt-get -y install tree \
&& apt-get -y install jq \
&& apt-get -y install bridge-utils
```
- Docker 설치
```bash 
apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common > /dev/null 2>&1 \
&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
&& add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
&& apt-get update \
&& apt-get -y install docker-ce docker-ce-cli containerd.io > /dev/null 2>&1
```
