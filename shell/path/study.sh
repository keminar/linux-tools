#!/bin/bash

TEST="ababab"
echo "定义变量TEST"
echo $TEST

echo "从左边找删除字符a,必须是以a开头"
echo "${TEST#a}"

echo "从左边找删除变符b和前面的任意字符"
echo "${TEST#*b}"

echo "从左边找删除变符b和前面的任意字符N次"
echo "${TEST##*b}"

TEST="abcd"
echo "定义变量TEST"
echo $TEST

echo "从左边找删除变符b和前面和后面的任意字符"
echo "${TEST##*b*}"


TEST="ababab"
echo "定义变量TEST"
echo $TEST

echo "从右边找删除字符b,必须是以b结尾"
echo "${TEST%b}"

echo "从右边找删除变符a和后面的任意字符"
echo "${TEST%a*}"

echo "从右边找删除变符a和后面的任意字符N次"
echo "${TEST%%a*}"

TEST="abcd"
echo "定义变量TEST"
echo $TEST

echo "从右边找删除变符b和前面和后面的任意字符"
echo "${TEST%%*b*}"

