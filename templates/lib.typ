// 공통: 데이터 로드, 페이지 스타일, 헤더
#import "@preview/iconify:0.5.3": icon, provide-icons

// 데이터 파일. 빌드 시 --input data=/경로 (--root 기준) 로 바꿀 수 있음
#let data = yaml(sys.inputs.at("data", default: "../data/career.yaml"))

// 연락처 type별 (Tabler 아이콘, 링크 생성). 아이콘 추가 시 icons/tabler.json 갱신 (README 참고)
#let contact-kinds = (
  phone: ("tabler:device-mobile", v => "tel:" + v.replace("-", "")),
  email: ("tabler:mail", v => "mailto:" + v),
  homepage: ("tabler:home", v => "https://" + v),
  github: ("tabler:brand-github", v => "https://github.com/" + v),
  linkedin: ("tabler:brand-linkedin", v => "https://www.linkedin.com/in/" + v),
)

// 포인트 색. 빌드 시 --input accent="#xxxxxx" 로 바꿔볼 수 있음
#let accent = rgb(sys.inputs.at("accent", default: "#2858b4"))
#let muted = gray.darken(35%)
// 선 색 (포인트 색은 글자에만)
#let rule = luma(190)

#let setup(title: "", body) = {
  set document(title: title, author: data.profile.name)
  set page(paper: "a4", margin: (x: 1.8cm, y: 1.6cm))
  set text(font: ("Pretendard", "Noto Sans KR"), size: 10pt, lang: "ko")
  set par(leading: 0.65em, spacing: 0.8em)
  set list(spacing: 0.55em, marker: text(fill: muted)[•])
  show heading.where(level: 1): it => block(
    sticky: true,
    above: 1.8em,
    below: 0.9em,
    width: 100%,
    inset: (bottom: 0.35em),
    stroke: (bottom: 0.8pt + rule),
    text(size: 12.5pt, weight: "bold", tracking: 0.03em, it.body),
  )
  provide-icons(json("../icons/tabler.json"))
  body
}

// 보조 정보 (작고 회색)
#let meta(body) = text(size: 9pt, fill: muted, body)

// YAML 문장을 Typst 마크업으로 렌더링. *강조*는 포인트 색 굵게
#let md(s) = {
  show strong: set text(fill: accent)
  eval(s, mode: "markup")
}

#let header() = {
  let p = data.profile
  text(size: 26pt, weight: "bold", p.name)
  h(0.7em)
  text(size: 12pt, weight: "medium", fill: accent, p.title)
  v(0.1em)
  text(size: 11pt, weight: "medium", p.headline)
  v(0.1em)
  let items = p.contacts.map(c => {
    let (name, url) = contact-kinds.at(c.type)
    link(url(c.value))[#icon(name, height: 1.1em, y: -0.25em) #c.value]
  })
  meta(items.join(h(0.7em) + "|" + h(0.7em)))
}

// 왼쪽 제목, 오른쪽 기간
#let entry(title, period) = grid(
  columns: (1fr, auto),
  text(size: 10.5pt, weight: "bold", title), meta(period),
)
