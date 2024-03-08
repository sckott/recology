---
name: pytaxize-itis
layout: post
title: pytaxize - low level ITIS functions
date: 2014-12-26
author: Scott Chamberlain
sourceslug: _drafts/2014-12-24-pytaxize-itis.md
tags:
- python
- taxonomy
---

I've been working on a Python port of the R package `taxize` that I maintain. It's still early days with this Python library, I'd love to know what people think. For example, I'm giving back Pandas DataFrame's from most functions. Does this make sense?

## Installation

```
sudo pip install git+git://github.com/sckott/pytaxize.git#egg=pytaxize
```

Or `git clone` the repo down, and `python setup.py build && python setup.py install`

## Load library

```python3
import pytaxize
```

## ITIS ping

```python3
pytaxize.itis_ping()
```

```python3
'This is the ITIS Web Service, providing access to the data behind www.itis.gov. The database contains 665,266 scientific names (501,207 of them valid/accepted) and 122,735 common names.'
```

## Get hierarchy down from tsn

```python3
pytaxize.gethierarchydownfromtsn(tsn = 161030)
```

```python3
      tsn rankName       taxonName    parentName parentTsn
0  161048    Class   Sarcopterygii  Osteichthyes    161030
1  161061    Class  Actinopterygii  Osteichthyes    161030
```

## Get hierarchy up from tsn

```python3
pytaxize.gethierarchyupfromtsn(tsn = 37906)
```

```python3
               author  parentName parentTsn rankName taxonName    tsn
0  Gaertn. ex Schreb.  Asteraceae     35420    Genus   Liatris  37906
```

## Get rank names

```python3
pytaxize.getranknames()
```

```python3
    kingdomname rankid      rankname
0      Bacteria     10       Kingdom
1      Bacteria     20    Subkingdom
2      Bacteria     30        Phylum
3      Bacteria     40     Subphylum
4      Bacteria     50    Superclass
5      Bacteria     60         Class
6      Bacteria     70      Subclass
7      Bacteria     80    Infraclass
8      Bacteria     90    Superorder
9      Bacteria    100         Order
10     Bacteria    110      Suborder
11     Bacteria    120    Infraorder
12     Bacteria    130   Superfamily
13     Bacteria    140        Family
14     Bacteria    150     Subfamily
15     Bacteria    160         Tribe
16     Bacteria    170      Subtribe
17     Bacteria    180         Genus
18     Bacteria    190      Subgenus
19     Bacteria    220       Species
20     Bacteria    230    Subspecies
21     Protozoa     10       Kingdom
22     Protozoa     20    Subkingdom
23     Protozoa     25  Infrakingdom
24     Protozoa     30        Phylum
25     Protozoa     40     Subphylum
26     Protozoa     45   Infraphylum
27     Protozoa     47    Parvphylum
28     Protozoa     50    Superclass
29     Protozoa     60         Class
..          ...    ...           ...
150   Chromista    190      Subgenus
151   Chromista    200       Section
152   Chromista    210    Subsection
153   Chromista    220       Species
154   Chromista    230    Subspecies
155   Chromista    240       Variety
156   Chromista    250    Subvariety
157   Chromista    260          Form
158   Chromista    270       Subform
159     Archaea     10       Kingdom
160     Archaea     20    Subkingdom
161     Archaea     30        Phylum
162     Archaea     40     Subphylum
163     Archaea     50    Superclass
164     Archaea     60         Class
165     Archaea     70      Subclass
166     Archaea     80    Infraclass
167     Archaea     90    Superorder
168     Archaea    100         Order
169     Archaea    110      Suborder
170     Archaea    120    Infraorder
171     Archaea    130   Superfamily
172     Archaea    140        Family
173     Archaea    150     Subfamily
174     Archaea    160         Tribe
175     Archaea    170      Subtribe
176     Archaea    180         Genus
177     Archaea    190      Subgenus
178     Archaea    220       Species
179     Archaea    230    Subspecies
```

## Search by scientific name

```python3
pytaxize.searchbyscientificname(x="Tardigrada")
```

```python3
           combinedname     tsn
0    Rotaria tardigrada   58274
1  Notommata tardigrada   58898
2   Pilargis tardigrada   65562
3            Tardigrada  155166
4      Heterotardigrada  155167
5      Arthrotardigrada  155168
6        Mesotardigrada  155358
7          Eutardigrada  155362
8   Scytodes tardigrada  866744
```

## Get accepted names from tsn

```python3
pytaxize.getacceptednamesfromtsn('208527')
```

If accepted, returns the same id

```python3
'208527'
```

## More

For the other functions see https://github.com/sckott/pytaxize/blob/master/pytaxize/itis.py
