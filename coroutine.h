/*
 * Copyright (c) 2018, ivan_allen@163.com 
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice, this
 *   list of conditions and the following disclaimer in the documentation and/or
 *   other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#ifndef __COROUTINE_H__
#define __COROUTINE_H__

#define NR_TASKS 10240 // 每个线程最多允许 10240 个协程
#define STACK_SIZE 1024*128 // 32bit 128*4K  64bit 128*8K 

#define COROUTINE_RUNNING 0
#define COROUTINE_SLEEP 1
#define COROUTINE_EXIT 2

struct task_struct_t;
// 每个线程持有一个此结构体，用来登记协程
struct thread_env_t {
    int task_count; // 当前任务个数，最小为 1，因为主协程也算一个任务
    struct task_struct_t *current; // 当前线程中正在运行的那个协程
    struct task_struct_t *task[NR_TASKS]; // 线程最多持有 10240 个协程
};

struct task_struct_t {
  int id; // 协程 id
  unsigned int wakeuptime; // 线程唤醒时间
  void *esp; // 保存 esp, 64bit 里叫 rsp，不要改动这个字段的位置！
  void *(*co_fn)(void *);
  void *arg; // 作参数，暂未使用
  struct thread_env_t *thread_env; // 指向自己的线程环境
  int status; // 协程状态
  void *stack[STACK_SIZE]; // 协程运行栈。
};


int co_create(int *cid, void *(*start_routine)(void *), void *arg);
int co_join(int cid);
void co_sleep(int seconds);

#endif //__COROUTINE_H__
