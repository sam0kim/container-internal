# container-internal
컨테이너 인터널 실습 리포입니다 

## 실습 환경 갖추기
### 실습 안내
- Mac M1(arm) 환경에서 QEMU 와 Vagrant 기반으로 테스트 되었습니다

### 실습 도구 
- Vagrant 공식 다운로드 및 설치 https://www.vagrantup.com/downloads

Mac M1 환경에서 환경 설치 방법은 다음과 같습니다.

설치 방법
```bash
# vagrant 설치
brew install vagrant --cask

# qemu 설치
brew install qemu

# plugin 설치
vagrant plugin install vagrant-qemu
```

### 실습 환경
아래 Vagrantfile을 사용합니다.
- Mac M1,arm계열 https://raw.githubusercontent.com/sam0kim/container-internal/main/m1/Vagrantfile

Vagrant 기본 사용법. vagrant는 "Vagrantfile" 경로를 기준으로 동작합니다.
```bash
# VM 종료와 기동
$ vagrant halt
$ vagrant up

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
