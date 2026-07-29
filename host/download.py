import ssgetpy

mtx = ['human_gene1', 'human_gene2', 'nd6k', 'TSOPF_RS_b2052_c1', 'thread', 'TSOPF_FS_b300_c1', 'TSOPF_FS_b300', 'TSOPF_RS_b678_c1', 'sme3Db', 'smt', 'nd3k', 'Trec14', 'heart1', 'c8_mat11', 'exdata_1', 'TSC_OPF_1047', 'appu', 'crystk03', 'nemeth26', 'nemeth23', 'nemeth24', 'raefsky3', 'heart3', 'heart2', 'raefsky4', 'msc10848', 'nemeth21', 'msc23052', 'bcsstk36', 'gyro_k', 'olafu', 'nemeth20', 'cbuckle', 'Trec13', 'raefsky1', 'psmigr_3', 'psmigr_1', 'psmigr_2', 'gyro', 'nemeth10', 'crystk01', 's2rmq4m1', 'bcsstk28', 's3rmt3m3', 't2d_q9', 'bcsstk24', 'ted_B', 'bodyy6', 'bodyy4', 'bcsstk15', 'ex9', 'Goodwin_017', 'epb1', 'dw8192', 'dendrimer', 'Goodwin_013', 'nasa1824', 'plbuckle', 'tomography']

for m in mtx:
    result = ssgetpy.search(name=m)
    result.download(format='MM', destpath='data', extract=True)
