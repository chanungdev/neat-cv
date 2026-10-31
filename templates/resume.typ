#import "lib.typ": *
#show: setup.with(title: data.profile.name + " 이력서")

#header()

= 소개
#data.profile.summary

= 기술 스택
#for s in data.skills [
  - *#s.category*: #md(s.items.join(", "))
]

= 경력
#for e in data.experience [
  #let title = [#e.company · #text(fill: accent, e.role)]
  #if "highlights" in e [
    // 주요 수행 내역이 있으면 회사 단위로 묶어 목록 표시
    #block(below: 1.6em)[
      #entry(title, e.period)
      #for h in e.highlights [
        - #md(h)
      ]
    ]
  ] else [
    #entry(title, e.period)
  ]
]

= 주요 프로젝트
#for p in data.projects [
  #block(below: 1.6em, breakable: false)[
    #entry(p.name, p.period)
    #meta[#p.client · #p.role] \
    #md(p.impact)
  ]
]

= 학력
#for ed in data.education [
  #entry(ed.school + " " + ed.major, ed.period)
]

#if data.at("certifications", default: ()).len() > 0 [
  = 자격증
  #for c in data.certifications [
    #entry([#c.name #h(0.5em) #meta(text(weight: "regular", c.issuer))], c.date)
  ]
]
