# my_calender

MY Calender Project
참여자 - 재범, 현태

## 12.17

1. 달력 구성 논의(구체적인 container 배치 등)
2. 기본 화면 구성 시작(ing)
3. N주차 표시 알고리즘 도입(?)

## 12.18

1. 달력 일자 알고리즘 완성

내일 추가 예정
1. 1, 5, 6 주차 없애기 if 문 사용하여 구현
2. 달력 화면 레이아웃 개선

## 12.19

1. 월에 따른 1, 5, 6주차 없애기 성공
2. 달력 레이아웃 중 sizedbox 넣어서 간격 줌

내일 계획
1. hive box 써서 to-do를 모아두는 library 구현
2. 현재 표시하고 있는 월 -> 어디에 저장할지 등 정하기

## 12.20

1. 커서 클래스 구현 시작, dayCal을 커서 클래스 method로 옮김
2. daylist 초기화 과정에서 양옆으로 초기화, 즉 이번 달 1일 전에 위치한 날짜들을 이전 달 30, 31일 등으로 초기화
3. scheduleClass 구현 시작 -> 아직 형태만


내일 계획
1. 커서 구현 -> 컨테이너 클래스를 먼저 정의해야함
2. 컨테이너 customclass화 (1. 커서 표시, 2. 일정 존재유무 표시, 3. 이모티콘, 4. 월별에 따라 없어져야하는지 아닌지, 5. ontap 터치시에 커서 거기로 이동)
3. 컨테이너 내에서 gestureDetector 써서 ontap method로 클릭하면 setstate 시키기 + isCursorOn 변수를 바꿔서 컨테이너에 커서 위치하는 것처럼 표현
4. 주차 화면 표현할 때 커서 위치에 따라 주차 다르게 표시하는걸로
5. *!!* 달이 바뀌어서 커서가 새로 호출될때는 generateDaylist를 자동으로 호출하게 아니면 잊지말고 넣어주기....

## 12.21

1. Text Alignment 왼쪽으로 수정하고 오른쪽에는 일정을 확인할 수 있도록 작은 원을 만듬
2. 요일 선택했을 때 날짜 위에 생기는 원 만듬

내일 계획
1. cursor가 위치한 날짜에만 원 띄우기
2. 다음 달로 이동하는 버튼 만들기
3. 현재 위치로 이동하는 버튼
4. 컨테이너 내에서 gestureDetector 써서 ontap method로 클릭하면 setstate 시키기 cursor에 datetime 대입해서 if 문으로 검사
5. hive 사용
6. 할일 추가버튼 옆에 이모티콘 추가 버튼 배치


## 12.22

1. cursor가 위치한 날짜에만 원 띄우기 구현 완료
2. 각 날짜 container 클릭하면 해당 날짜로 cursor가 이동
3. 앱 전체에 provider 적용
4. 현재 위치로 이동하는 버튼 구현

내일 계획
1. hive 사용!! -> 할 일 목록 모음집 만들기
2. 각 일자 아래에 할일 목록 보여주기
3. 할일 추가 화면 구현
4. 이모티콘 추가 function 구현
5. appbar 버튼들 재정렬

## 12.23

1. 주간 화면 구성
2. Multi Provider 를 사용해 화면 전환
3. appBar 임시 구현 완료

내일 계획
1. hive 사용
2. 할일 목록 보여주기
3. 할일 추가 화면 구현
4. 이모티콘 추가 function 구현

## 12.24

1. 어플 방향성에 대한 아이디어 회의 진행
-> daily to-do 나눠서 넣기 (약속, todo로)
-> 진척도 같은거 (ex 씨앗, 새싹 꽃 등...)
2. hive 진행 중 

내일 계획
1. hive 집중 공략
2. 나머지는 hive 마무리하고 위에 참고


## 12.25
1. hive 구현 성공! ★
- 아래 floating 버튼으로 test 완료


다음 계획
1. 할일 리스트 보여주기
2. 할일 추가화면 구현

## 12.26
1. 색상 팔레트 추가(palette.dart)
2. 일요일 날짜들 빨강으로 변경
3. To-do 바 대충 만듬

## 12.27
1. ListView 구현
2. ListView에 Hive 적용
3. type 문제 해결(dynamic 사용)

## 12.28
1. Hive 일정 추가 및 디스플레이 구현
2. Custom ScrollView 를 만들어 TextForm Field 넣음
3. 일정 존재하는 날에만 빨간 원 보이게 함

다음 계획
1. 일정 추가 화면 만들기
2. TextForm Field 개선
3. 반복문으로 월간 화면 단순화

## 12.29
1. textformfield 구현 
- 입력하고 submit하면 hive에 저장됨
- 다른 곳 누르면 out focus(상위 계층에 gesturedetecture)

다음 계획
1. 일정 수정 기능 **
2. submit 했을 때 focus 안풀리도록
3. 1 이후 -> extformfield의 오른쪽 부분에 수정버튼 추가해서, 처음 추가 시부터 일정 수정 화면에 접근할 수 있게
4. 코드 반복되는거 좀 깔끔하게...

나혼자 코딩 - 재범
1. WeekDays와 MonthDays 위젯의 내용이 완전히 동일하여 OneDay라는 위젯 하나로 만듦.
2. DayofWeek(월화수목금토일 있는 Row)를 Padding에 씌워 반환하도록 변경. 위아래로 있던 SizedBox 삭제
3. CustomAppbar.dart 신설하여 Appbar 개발 중...
4. Cursor 클래스에 isMonth 추가하고 기존 isMonth 삭제
5. Appbar의 날짜 표기는 구분했고 아직 달/주 이동 버튼은 구현함
6. 나중에 월간 화면과 주간 화면을 애니메이션으로 전환할 생각임
7. CalenderBanner 클래스를 calenderElement.dart 에 추가함
8. 할 일 리스트 UI 개선중


## 12.30
1. TextFrom Field 에 Info 버튼 추가하기
2. BottomSheet 도입
3. Card 형태로 Todo 넣음

다음 계획
1. BottomSheet 완성

혼자 코딩 - 재범
1. TextFormField 를 Card 로 만듦
2. Card 보다 테두리 있는 Container 가 더 나아 보여서 변경
3. MaterialApp 아래에 splashColor 와 highlightColor 를 투명하게 설정하여 버튼 누를 시 효과 투명하게 변경
4. drawer 의 Icon 커스텀하여 넣음 drawer 에 무엇을 넣을지는 회의 필요
5. TodoBanner 를 calenderElement 에 추가함 아직 미완성
6. 구분감을 높이기위해 선택한 컨테이너 색 변경함
7. 아이콘 일단 한번 추가해봄
8. 스페이스바 눌렀을 때에도 값이 들어가는 문제 수정해야함

## 12.31

1. bottomsheet 구조 회의
2. bottomsheet 구현 시작

다음 계획

1. textformfield 입력받을 때 spacebar 만을 입력받는 문제 해결해야함
2. 빈 textformfield 눌러서 bottomsheet 띄우면 빈 리스트를 삽입해서 일정 있는것처럼 표시됨... -> 취소

혼자 코딩 - 재범
1. WeekCal 과 MonthCal 리팩토링해서 하나로 합침
2. 주간 달력과 월간 달력을 WeekAndMonth.dart 에 따로 정리해서 삼항 연산자로 사용
3. AnimatedCrossFade 활용하여 애니메이션 넣음
4. Drawer 안 뜨던 문제는 해결
5. 빈 리스트가 저장되던 문제 해결
6. bottomSheet 디자인 조금 변경, 삭제 버튼 모양만 추가
7. 텍스트 필드 위로 조금 올라가있는게 좀 불편함
8. 상태바(statueBar) 색 변경함(아예 없애는 방법도 있음)

## 1.1
1. 글자수 오버플로우 해결
2. 양쪽 공백 제거 및 공백만 제출받는 문제 해결
3. build 문제 해결책을 찾아봄
4. 삭제버튼 구현

다음 계획
1. initial text 값을 unfocus 했을 때 submit 하도록 수정
2. bottom sheet 내용물 완성
3. 일정 날짜 변경 버튼 구현

혼자 코딩
1. 해당 날짜에 할일 숫자를 표시하도록 수정

## 1.2
1. bottomsheet 인자 수정
2. scheduleClass에 memo element 추가 -> build runner 까지 돌림

다음 계획

1. bottomsheet "완료" 버튼 기능오류 해결(unfocus 했을 때 값 대입이 안됨...)
2. bottomsheet 완성!!!

## 1.4
1. bottomsheet 에서 name 과 memo 저장 가능하게 함
2. toggle buttom 만듦
3. 삭제했을 때 빈 리스트이면 키를 제거하게 함
4. listwheelscrollview를 도입

다음 계획
1. listwheelscrollview로 날짜 변경하게 만들 예정
2. 시간도 scrollview로 변경할 수 있게
3. 알"림" 기능 넣기

## 1.5
1. DatePicker cupertino date picker로 구현
2. 날짜 이제 정상적으로 저장함
3. 일단 animated container 넣음

다음 계획
1. 애니메이션 정상적으로 보이게 하기
2. 시간 변경도 구현
3. 알림 기능 구현

## 1.6

1. timepicker 구현
2. scheduleClass 에서 시간과 날짜 통합
3. 날짜 변경 구현하긴 함
4. boxController 생성

다음 계획
1. 새 일정에서 이름이랑 메모가 다른곳 tap했을 때 저장이 안됨(사라짐)
2. rebuild 되면서 날짜 현재랑 바뀐거랑 비교(tmpDate 정의 위치 해결)
3. 날짜 이동하면 initalValue가 이상해지는 문제 해결

## 1.7

1. bottomSheet 구조 및 변수 수정
2. bottomSheet 일정과 시간 관련 버그 수정

다음 계획
1. 알람 기능 추가 (푸시 알림으로)
2. 일정 모아보기 기능 추가

## 1.8
1. 푸시 알림 기능 도입
2. 알림 켜는 화면 만듦

다음 계획
1. 푸시 알림 완성
2. 일정 모아보기 기능 추가
3. 일정 순서 변경 기능 추가

## 1.9
1. timezone 사용해서 알림 뜨게 함

## 1.10
1. 알림 기능 완성함

다음 계획
1. 일정 모아보기 만들기

## 1.11 
나 혼자 코딩 - 현태
1. 불필요한 위젯 삭제 (month, week appbar)
2. const 등등 추가
3. dart 파일 통합
4. textformfield border 코드 깔끔하게 변경

1. Reorderable List View 로 변경하여 구현

다음 계획
1. Card 레이아웃 수정 및 디자인 통일
2. Reorder 할 때 빈 칸 생기는 문제 수정
3. 모아보기 기능 구현 논의

## 1.12
1. Reorder 기능 구현 완료(sliver-reorder 사용)
2. 알람 울리면 시계 아이콘 표시
3. 시간 넣으면 container에 그 시간 표시

다음 계획
1. 일정 반복
2. 이모티콘 -> 진척도와 관련해서 추가 / 진척도 확인화면을 어떻게 구성할 것인지
3. 완료된 일정들을 어떻게 할지?

혼자 코딩 - 재범
1. 색 설정 기능 추가

---
# 추후 수정해야할 요소들

## 12.23
1. 주간 보기 화면에서 아래에 아주 넓은 빈칸을 어떡해야하는지 결정....

## 12.25
1. 주간 화면 채울만한 요소들 고민해보기
2. 아이콘 이미지 그리든지 잘 찾든지 해결하기
3. 색감 재정비
4. 할일 리스트 보여주는 버튼 추가

## 12.29
1. 월요일이나 일요일 중 시작하는 날짜 정하는 기능 구현할지 정하기

## 1.4
1. 일정 반복 논의하기

## 1.10
1. 알림 울리고 나면 알림 토글 false로 바꾸기
2. 체크박스도 어찌어찌 구현해야됨
3. 알림 설정하면 설정이 됐는지 안됐는지 표시

## 1.11
1. 키보드 <-> bottomsheet 전환시 애니메이션이 너무 뻑뻑함 개선 필요
2. 월간 새 일정 클릭시 키보드 치는거 안보임 -> 바로 수정화면 띄우던가 개선 필요

