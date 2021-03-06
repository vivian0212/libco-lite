/*
 * Copyright (c) 2018, ivan_allen@163.com. 
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

/*void switch_to(struct task_struct *cur, struct task_struct *next)*/

.section .text
.global switch_to
switch_to:
#if defined(__i386__)
  pushl %ebp
  movl %esp, %ebp /* 更改栈帧，以便寻参 */

  /* 保存现场 */
  pushl %edi
  pushl %esi
  pushl %ebx
  pushl %edx
  pushl %ecx
  pushl %eax
  pushfl
 
  /* 准备切换栈 */
  movl 8(%ebp), %eax /* 取 current 基址放到 eax */
  movl %esp, 8(%eax) /* 保存当前 esp 到线程结构体 */ 
  movl 16(%ebp), %eax /* 取下一个协程结构体基址*/
  /* movl %eax, current 更新 current 到外面实现 */
  movl 8(%eax), %esp /* 切换到下一个线程的栈 */

  /* 恢复现场, 到这里，已经进入另一个线程环境了，本质是 esp 改变 */
  popfl
  popl %eax
  popl %edx
  popl %ecx
  popl %ebx
  popl %esi
  popl %edi

  popl %ebp
  ret
#elif defined(__x86_64__)
  pushq %rbp
  movq %rsp, %rbp
 
  /* 保存现场 */
  pushq %rdi
  pushq %rsi
  pushq %rbx
  pushq %rdx
  pushq %rcx
  pushq %rax
  pushfq
  pushq %r8
  pushq %r9
  pushq %r10
  pushq %r11
  pushq %r12
  pushq %r13
  pushq %r14
  pushq %r15

  /* 准备切换栈 */
  movq %rdi, %rax /* current 参数保存在 rdi 里 */
  movq %rsp, 8(%rax) /* 取当前栈顶保存到 current->esp */
  movq %rsi, %rax /* next 参数 保存在 rsi 里 */
  /* movq %rax, current  更新 current 到外面实现 */
  movq 8(%rax), %rsp /* 切换到下一个协程 */

  popq %r15
  popq %r14
  popq %r13
  popq %r12
  popq %r11
  popq %r10
  popq %r9
  popq %r8
  popfq
  popq %rax
  popq %rcx
  popq %rdx
  popq %rbx
  popq %rsi
  popq %rdi

  popq %rbp
  ret
#endif
