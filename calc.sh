#!/bin/sh
num1=100
num2=$num1+200
echo $num2

# expr 사용 시 공백 주의
num3=$(expr $num1 + 200)
echo $num3

# 곱셈 기호 앞에 역슬래시를 사용하여 이스케이프 처리
num4=$(expr \( $num1 + 200 \) / 10 \* 2)
echo $num4

exit 0
