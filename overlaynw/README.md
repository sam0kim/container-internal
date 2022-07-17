# 오버레이 네트워크

overlay network 실습을 위한 vagrant 환경구성 방법을 설명합니다.

### 디렉토리
```
overlaynw               # ----- 오버레이 네트워크 실습폴더
  ㄴ overlaynet          # ----- 다이내믹 오버레이 실습스크립트
     arpd.py              # ----- L2,L3 miss event를 catch하여 arp cache,fdb 등록 
     attach_ctn.sh        # ----- 컨테이너 생성 스크립트
     check.sh             # ----- check app_solicit. neighbor 이벤트 전송 활성화 여부
     create_overlay.sh    # ----- vxlan, bridge 생성 스크립트
     l2l3miss.py          # ----- L2,L3 이벤트 확인 데몬
     reset.sh             # ----- 초기화
  README.md             # ----- 실습가이드 문서
  Vagrantfile           # ----- vagrant 실습 환경 구성 파일
```

### 환경 구성

Git clone
```bash
$ git clone https://github.com/sam0kim/container-internal.git
```

VM 생성
```bash
$ cd container-internal/overlaynw
$ vagrant up
```

VM 확인
```bash
$ vagrant status
```

VM 접속
```bash
### 터미널#1 접속
$ vagrant ssh ubuntu1804

### 터미널#2 접속
$ vagrant ssh ubuntu1804-2

```