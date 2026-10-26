#import "lib.typ": *
#show: setup.with(title: data.profile.name + " 이력서")

#header()
#v(1em)
#highlight-cards()

= 요약
#data.profile.summary

= 기술 스택
#for s in data.skills [
  - *#s.category*: #md(s.items.join(", "))
]

= 경력
#for e in data.experience [
  #entry([#e.company · #text(fill: accent, e.role)], e.period)
]

= 주요 프로젝트
#for p in data.projects [
  #block(below: 1.6em)[
    #entry(p.name, p.period)
    #meta[#p.client · #p.role] \
    #md(p.impact)
  ]
]

= 학력
#for ed in data.education [
  #entry(ed.school + " " + ed.major, ed.period)
]
