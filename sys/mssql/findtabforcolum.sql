SELECT table_name=sysobjects.name,
column_name=syscolumns.name,
datatype=systypes.name,
length=syscolumns.length
FROM sysobjects
JOIN syscolumns ON sysobjects.id = syscolumns.id
JOIN systypes ON syscolumns.xtype=systypes.xtype
WHERE syscolumns.name='?'

