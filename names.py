NAMES = ['arnold schwarzenegger', 'alec baldwin', 'bob belderbos',
         'julian sequeira', 'sandra bullock', 'keanu reeves',
         'julbob pybites', 'bob belderbos', 'julian sequeira',
         'al pacino', 'brad pitt', 'matt damon', 'brad pitt']


def dedup_and_title_case_names(NAMES):
    """Should return a list of title cased names,
       each name appears only once"""
    NAMES1=[]
    for x,y in enumerate(NAMES):
        if x == 0:
            NAMES1.append(y)
        elif y not in NAMES1:
            NAMES1.append(y)
    NAMES1
    lst=[]
    for x in NAMES1:
        lst.append(x.title())
    return lst


def sort_by_surname_desc(names):
    """Returns names list sorted desc by surname"""
    names = dedup_and_title_case_names(NAMES)
    d = dict(x.split(" ") for x in names)
    listofTuples = sorted(d.items() , reverse=True, key=lambda x: x[1])
    res = [' '.join(tups) for tups in listofTuples] 
    return res
    


def shortest_first_name(names):
    """Returns the shortest first name (str).
       You can assume there is only one shortest name.
    """
    names = dedup_and_title_case_names(NAMES)
    d = dict(x.split(" ") for x in names)
    newlist = d.items()
    sortedlist = sorted(newlist, key=lambda s: len(s[0]))
    value = [' '.join(tups) for tups in sortedlist] 
    return value[0]