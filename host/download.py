from ssgetpy import search

for m in search(group = 'HB', nzbounds = (None, 1000)):
    m.download(format="MM", destpath="test/", extract=True)
