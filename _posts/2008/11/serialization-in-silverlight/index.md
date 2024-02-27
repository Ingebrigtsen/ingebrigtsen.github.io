---
title: "Serialization in Silverlight"
date: "2008-11-29"
---

I am working on a project were we have a challenge seeing that I work most of the week from my home office. The problem is that due to security at the location, there is no way to access the database we're working with through VPN or similar. I can't take the database from the site either. So, we need to have some sort of fake version of the data so that I can get my job done.  
  
My initial idea was to just have a local SQL database, seeing that our Silverlight application is connecting through a servicelayer and we could pretty much just change the connectionstring. But that is jus too easy. :)  I started looking at how I could have data stored within the Isolated Storage and serialize data back and forth from this. It will be handy for other parts of the project, so it wouldn't be a complete waste.  
  
Anyhow, the XmlSerializer one is familiar with from the desktop framework is not present in the Silverlight scaled down version of the framework. But, since the WCF support in Silverlight supports SOAP, it must be able to serialize and deserialize stuff back and forth across the wire. There is a class called DataContractSerializer that does the job. Only thing is, everywhere I looked and samples I came across, they claimed you had to decorate whatever object you wanted to work with, with \[DataContract\] for the class and \[DataMember\] for the members. This actually proves to not be the case, which is just brilliant for my case.  
  
The result is that I made a couple of helper methods to do it all.  
  
\[code:c#\]  
        public string Serialize<T>(T data)  
        {  
            using (var memoryStream = new MemoryStream())  
            {  
                var serializer = new DataContractSerializer(typeof (T));  
                serializer.WriteObject(memoryStream, data);  
  
                memoryStream.Seek(0, SeekOrigin.Begin);  
  
                var reader = new StreamReader(memoryStream);  
                string content = reader.ReadToEnd();  
                return content;  
            }  
        }  
  
        public T Deserialize<T>(string xml)  
        {  
            using( var stream = new MemoryStream(Encoding.Unicode.GetBytes(xml)) )  
            {  
                var serializer = new DataContractSerializer(typeof (T));  
                T theObject = (T)serializer.ReadObject(stream);  
                return theObject;  
            }  
        }  
\[/code\]   
  
A sample with a couple of classes:  
  
\[code:c#\]  
    public class WorkPosition  
    {  
        public double PositionSize { get; set; }  
    }  
  
    public class Employee  
    {  
        public Employee()  
        {  
            this.WorkPositions = new WorkPosition\[\]  
                                     {  
                                        new WorkPosition {PositionSize=50d},  
                                        new WorkPosition {PositionSize=25d},  
                                        new WorkPosition {PositionSize=25d},  
                                     };  
        }  
  
        public string FirstName { get; set; }  
        public string LastName { get; set; }  
  
        public WorkPosition\[\] WorkPositions { get; set; }  
    }  
  
    public partial class Page : UserControl  
    {  
        public Page()  
        {  
            InitializeComponent();  
  
            var employee = new Employee {FirstName = "John", LastName = "Doe" };  
  
            string xml = this.Serialize(employee);  
  
            var deserializedEmployee = this.Deserialize<Employee>(xml);  
        }  
    }  
  
\[/code\]
