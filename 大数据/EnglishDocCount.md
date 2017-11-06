EnglishDocCount
-------

标签（空格分隔）： homework

---

```Java
public static Int lines = 0;   
public static class TokenizerMapper extends Mapper<Object,Text,Text,IntWritable>{
    private final static IntWritable one = new IntWritable(1);
    private Text word = new Text();
    public void map(Object key, Text value, Context context) 
    throws IOException,InterruptedException
    //这里的value是一行文本
    {
        lines += 1;
        StringTokenizer itr = new StringTokenizer(value.toString());
        while(itr.hasMoreTokens()){
            word.set(itr.nextToken());
            context.write(word,one);
        }
    }
}
```

```Java
public static class AvgReducer extends Reducer<Text, IntWritable, Text, IntWritable>{
    private FloatWritable result = new FloatWritable();
    public void reduce(Text key, Iterable<IntWritable> values, Context context) 
    throws IOException,InterruptedException 
    {
        int sumCount = 0;
        for(IntWritable val:values){
            sumCount += val.get();
        }
        float avgLineCount = (float)sumCount/lines;
        result.set(avgLineCount);
        context.write(key,result);
    }
}
```