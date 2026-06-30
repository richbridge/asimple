import { writeFileSync, mkdirSync, readdirSync, unlinkSync } from 'fs';
import { join } from 'path';

const dir = join(process.cwd(), 'content', 'posts');
mkdirSync(dir, { recursive: true });

const START_YEAR = 1927;
const END_YEAR = 2026;
const COUNT = END_YEAR - START_YEAR + 1;

const titles = [
  '春之笔记', '夏夜漫谈', '秋叶随笔', '冬雪沉思', '晨光微语',
  '星轨日记', '云端漫步', '雨后清音', '月下独酌', '风中絮语',
  '时光切片', '像素梦境', '代码诗行', '远程旅人', '静室思考',
  '浅滩拾贝', '深空回响', '薄雾清晨', '晚风来信', '量子花园',
  '离线时刻', '同步心跳', '缓存记忆', '异步人生', '编译人生',
  '递归之梦', '开源星图', '终端浪漫', '协议之外', '版本更迭',
];
const cats = ['随笔', '生活', '技术', '阅读'];

for (const file of readdirSync(dir)) {
  if (/^test-\d{4}\.md$/.test(file)) {
    unlinkSync(join(dir, file));
  }
}

for (let i = 0; i < COUNT; i++) {
  const year = START_YEAR + i;
  const slug = `test-${year}`;
  const path = join(dir, `${slug}.md`);
  const month = String((i % 12) + 1).padStart(2, '0');
  const title = `${titles[i % titles.length]} (${year})`;
  const cat = cats[i % cats.length];

  writeFileSync(
    path,
    `+++
date = '${year}-${month}-15T10:00:00+08:00'
draft = false
title = '${title}'
description = '测试文章 — ${year} 年轨道上的 quietly drifting planet.'
categories = ['${cat}']
+++

${year} 年的测试文章，用于轨道星系展示。
`,
    'utf8'
  );
}

console.log(`Done: ${COUNT} year test posts (${START_YEAR}–${END_YEAR})`);
