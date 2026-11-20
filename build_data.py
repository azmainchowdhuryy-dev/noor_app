#!/usr/bin/env python3
"""
assets/data/ এর JSON তৈরি করে সরাসরি উৎস-ডেটাসেট থেকে।
কোনো টেক্সট হাতে লেখা বা মুখস্থ বসানো হয়নি - সবই ডাউনলোড করে হুবহু কপি।
চালানোর নিয়ম:  python3 tools/build_data.py
"""
import json, re, sys, urllib.request, pathlib

Q = "https://raw.githubusercontent.com/fawazahmed0/quran-api/1"
H = "https://raw.githubusercontent.com/fawazahmed0/hadith-api/1/editions"
OUT = pathlib.Path(__file__).resolve().parent.parent / "assets" / "data"

# ছোট ১০টি সূরা (আপনি চাইলে তালিকা বদলাতে পারেন) ও প্রত্যাশিত আয়াত সংখ্যা
SURAHS = {105: 5, 106: 4, 107: 7, 108: 3, 109: 6, 110: 3, 111: 5, 112: 4, 113: 5, 114: 6}
BN_NAMES = {105: "আল-ফীল", 106: "কুরাইশ", 107: "আল-মাঊন", 108: "আল-কাউসার",
            109: "আল-কাফিরূন", 110: "আন-নাসর", 111: "আল-মাসাদ", 112: "আল-ইখলাস",
            113: "আল-ফালাক", 114: "আন-নাস"}

def get(url):
    with urllib.request.urlopen(url, timeout=60) as r:
        return json.loads(r.read().decode("utf-8"))

def skeleton(s):
    """তুলনার জন্য: হরকত/চিহ্ন ও আলিফ-ওয়াও-ইয়া জাতীয় বর্ণ বাদ দিয়ে শুধু ব্যঞ্জন কাঠামো"""
    s = re.sub(r"[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED\u0640\u08D3-\u08FF\u200b-\u200f\u202a-\u202e]", "", s)
    s = s.replace("ك", "ك").replace("ک", "ك").replace("ى", "ي").replace("ی", "ي")
    s = re.sub(r"[اأإآٱءئؤويى\s\"“”.،:\[\]()0-9٠-٩]|رقم", "", s)
    s = s.replace("ة", "ه")
    return s

problems = []

# ---------------- কুরআন ----------------
info = {c["chapter"]: c for c in get(f"{Q}/info.json")["chapters"]}
surahs = []
for n, expected in SURAHS.items():
    ar  = get(f"{Q}/editions/ara-quranuthmanihaf/{n}.json")["chapter"]   # King Fahd Complex, Hafs
    ar2 = get(f"{Q}/editions/ara-quransimple/{n}.json")["chapter"]       # স্বতন্ত্র দ্বিতীয় উৎস (alquran.cloud)
    bn  = get(f"{Q}/editions/ben-muhiuddinkhan/{n}.json")["chapter"]     # তানযিল: মুহিউদ্দীন খান
    en  = get(f"{Q}/editions/eng-ummmuhammad/{n}.json")["chapter"]       # তানযিল: Saheeh International
    for label, lst in (("arabic", ar), ("arabic2", ar2), ("bn", bn), ("en", en)):
        if len(lst) != expected:
            problems.append(f"সূরা {n}: {label} আয়াত সংখ্যা {len(lst)} (প্রত্যাশিত {expected})")
    # alquran.cloud-এর প্রথম আয়াতের আগে বিসমিল্লাহ জোড়া থাকে - তুলনার আগে বাদ দেওয়া হচ্ছে
    bism = skeleton("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
    for i in range(expected):
        if ar[i]["verse"] != i + 1 or bn[i]["verse"] != i + 1 or en[i]["verse"] != i + 1:
            problems.append(f"সূরা {n}: আয়াত নম্বর মেলেনি ({i+1})")
        other = skeleton(ar2[i]["text"])
        if i == 0 and other.startswith(bism):
            other = other[len(bism):]
        if skeleton(ar[i]["text"]) != other:
            problems.append(f"সূরা {n} আয়াত {i+1}: দুই আরবি উৎসের ব্যঞ্জন কাঠামো আলাদা\n   A={ar[i]['text']}\n   B={ar2[i]['text']}")
    c = info[n]
    surahs.append({
        "number": n,
        "name_arabic": c["arabicname"],
        "name_bn": BN_NAMES[n],
        "name_en": f'{c["name"]} ({c["englishname"]})',
        "ayahs_arabic": [a["text"] for a in ar],
        "transliteration": [],
        "translation_bn": [b["text"] for b in bn],
        "translation_en": [e["text"] for e in en],
        "audio_asset": "",
        "verified": True,
    })

# ---------------- হাদিস: চল্লিশ হাদিস (ইমাম নববী) ----------------
ar  = get(f"{H}/ara-nawawi.json")["hadiths"]
ar1 = get(f"{H}/ara-nawawi1.json")["hadiths"]
bn  = get(f"{H}/ben-nawawi.json")["hadiths"]
en  = get(f"{H}/eng-nawawi.json")["hadiths"]
if not (len(ar) == len(ar1) == len(bn) == len(en) == 42):
    problems.append(f"হাদিস সংখ্যা মেলেনি: {len(ar)}/{len(ar1)}/{len(bn)}/{len(en)}")
hadiths = []
for a, a1, b, e in zip(ar, ar1, bn, en):
    n = a["hadithnumber"]
    if not (a1["hadithnumber"] == b["hadithnumber"] == e["hadithnumber"] == n):
        problems.append(f"হাদিস {n}: নম্বর মেলেনি")
    if skeleton(a["text"]) != skeleton(a1["text"]):
        problems.append(f"হাদিস {n}: দুই আরবি সংস্করণ মেলেনি")
    hadiths.append({
        "id": f"nawawi_{n:02d}",
        "arabic": a["text"].replace("\u200b", ""),
        "bn": b["text"].replace("\u200b", ""),
        "en": e["text"].replace("\u200b", ""),
        "reference": f"চল্লিশ হাদিস (ইমাম নববী), হাদিস নং {n} / Forty Hadith of an-Nawawi, No. {n}",
        "category": "nawawi40",
        "tags": [],
        "verified": True,
    })

print("=== রিপোর্ট ===")
if problems:
    print(f"{len(problems)} টি সমস্যা পাওয়া গেছে:")
    for p in problems: print(" -", p)
    sys.exit("ডেটা লেখা হয়নি। সমস্যা মেটান।")
print(f"সূরা: {len(surahs)}টি, মোট আয়াত {sum(len(s['ayahs_arabic']) for s in surahs)}")
print(f"হাদিস: {len(hadiths)}টি")
print("সব যাচাই পাস।")

meta = {"schema_version": 1, "review_status": "machine-checked; scholar review pending"}
(OUT / "short_surahs.json").write_text(json.dumps({**meta, "items": surahs}, ensure_ascii=False, indent=2), encoding="utf-8")
(OUT / "hadiths.json").write_text(json.dumps({**meta, "items": hadiths}, ensure_ascii=False, indent=2), encoding="utf-8")
print("লেখা হয়েছে:", OUT)
