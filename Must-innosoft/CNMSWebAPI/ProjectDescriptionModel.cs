using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CNMSWebAPI.Models
{

    //public class Foundation
    //{
    //    public int status { get; set; }
    //    public int qty { get; set; }
    //}

    //public class Basement
    //{
    //    public int status { get; set; }
    //    public int qty { get; set; }
    //}

    //public class Podium
    //{
    //    public int status { get; set; }
    //    public int qty { get; set; }
    //}

    //public class LMezanine
    //{
    //    public int status { get; set; }
    //    public int qty { get; set; }
    //}

    //public class ProjectDescription
    //{
    //    public List<Foundation> Foundation { get; set; }
    //    public List<Basement> Basement { get; set; }
    //    public List<Podium> Podium { get; set; }
    //    public List<LMezanine> Mezanine { get; set; }
    //}

    //public class LowerRoof
    //{
    //    public int status { get; set; }
    //    public int qty { get; set; }
    //}

    //public class UpperRoof
    //{
    //    public int status { get; set; }
    //    public int qty { get; set; }
    //}

    //public class Floor    {
    //    public int status { get; set; }
    //    public int qty { get; set; }
    //}

    //public class List
    //{
    //    public string name { get; set; }
    //    public List<LowerRoof> LowerRoof { get; set; }
    //    public List<Floor> Floor { get; set; }
    //    public List<UpperRoof> UpperRoof { get; set; }
    //}

    //public class NameList
    //{
    //    public string name { get; set; }
    //    public List<List> list { get; set; }
    //}

    //public class ExternalWork
    //{
    //    public string externalId { get; set; }
    //    public string externalName { get; set; }
    //    public string uom { get; set; }
    //    public int qty { get; set; }
    //}

    //public class ProjectDescriptionModel
    //{
    //    public string ProjectId { get; set; }
    //    public List<ProjectDescription> ProjectDescription { get; set; }
    //    public List<NameList> nameList { get; set; }
    //    public List<ExternalWork> ExternalWorks { get; set; }
    //    public List<MainItem> MainItems { get; set; }
    //}
    //public class MainItem
    //{
    //    public string mainitem { get; set; }      
    //    public decimal cost { get; set; }
    //}
    public class Foundation
    {
        public int status { get; set; }
        public int qty { get; set; }
        public List<FoundationDe> FoundationDes { get; set; }
    }

    public class Basement
    {
        public int status { get; set; }
        public int qty { get; set; }
        public List<FoundationDe> FoundationDes { get; set; }
    }

    public class Podium
    {
        public int status { get; set; }
        public int qty { get; set; }
        public List<FoundationDe> FoundationDes { get; set; }
    }

    public class LMezanine
    {
        public int status { get; set; }
        public int qty { get; set; }
        public List<FoundationDe> FoundationDes { get; set; }
    }

    public class ProjectDescription1
    {
        public Foundation Foundation { get; set; }
        public Basement Basement { get; set; }
        public Podium Podium { get; set; }
        public LMezanine Mezanine { get; set; }
    }

    public class Floor
    {
        public int status { get; set; }
        public int qty { get; set; }
        public List<FoundationDe> FoundationDes { get; set; }
    }

    public class LowerRoof
    {
        public int status { get; set; }
        public int qty { get; set; }
        public List<FoundationDe> FoundationDes { get; set; }
    }

    public class UpperRoof
    {
        public int status { get; set; }
        public int qty { get; set; }
        public List<FoundationDe> FoundationDes { get; set; }
    }

    public class List
    {
        public string name { get; set; }
        public Floor Floor { get; set; }
        public LowerRoof LowerRoof { get; set; }
        public UpperRoof UpperRoof { get; set; }
    }

    public class NameList
    {
        public string name { get; set; }
        public List<List> list { get; set; }
    }

    public class ExternalWork
    {
        public string externalId { get; set; }
        public string externalName { get; set; }
        public string uom { get; set; }
        public int qty { get; set; }
    }

    public class MainItem
    {
        public string mainitem { get; set; }
        public decimal cost { get; set; }
    }

    public class ProjectDescriptionModel
    {
        public string ProjectId { get; set; }
        public ProjectDescription1 ProjectDescription { get; set; }
        public List<NameList> nameList { get; set; }
        public List<ExternalWork> ExternalWorks { get; set; }
        public List<MainItem> MainItems { get; set; }
    }
    public class FoundationDe
    {
        public string name { get; set; }
    }
}