#import "lib.typ": *
#show: setup.with(title: data.profile.name + " 경력기술서")

#header()

= 프로젝트 요약
#table(
  columns: (auto, auto, auto, 1fr),
  stroke: (x, y) => (bottom: if y == 0 { 0.8pt + rule } else { 0.5pt + gray.lighten(40%) }),
  inset: (x: 0.5em, y: 0.6em),
  table.header(..([기간], [프로젝트], [고객사], [핵심 성과]).map(strong)),
  ..data.projects.map(p => (meta(p.period), strong(p.name), p.client, md(p.impact))).flatten(),
)

= 프로젝트 상세
#for (i, p) in data.projects.enumerate() [
  // 프로젝트 사이 구분선
  #if i > 0 { block(above: 1.4em, below: 1.4em, line(length: 100%, stroke: 0.5pt + gray.lighten(40%))) }
  #block[
    #entry(p.name, p.period)
    #md(p.impact)
    #grid(
      columns: (4.5em, 1fr),
      row-gutter: 0.6em,
      meta[고객사], p.client,
      meta[역할], p.role,
      meta[기술 스택], p.stack.join(", "),
      meta[개요], p.summary,
    )
    #v(0.3em)
    *담당 업무 및 성과*
    #for h in p.highlights [
      - #md(h)
    ]
  ]
]
