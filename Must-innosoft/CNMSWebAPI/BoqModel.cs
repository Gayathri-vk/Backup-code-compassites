using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CNMSWebAPI.Models
{
    public class BoqModel
    {
        public string ProjectId { get; set; }
        public List<Task> Tasks { get; set; }
        public List<links> Links { get; set; }

        //const links = [{ id: 1, source: 1, target: 2, type: '0' }];
    }
    public class BoqMaster
    {
        public string id { get; set; }

        public string location { get; set; }
        public string mainitem { get; set; }
        public string locationname { get; set; }
        public string mainitemname { get; set; }
        public string subitem { get; set; }
        public string subsubitem { get; set; }
        public string start_date { get; set; }
        public string end_date { get; set; }
        public int duration { get; set; }
        public string boq { get; set; }
        public string task { get; set; }
        public string unit { get; set; }
        public decimal qty { get; set; }
        public decimal urate { get; set; }
        public decimal tcost { get; set; }
        public int step
        {
            get; set;

        }
        public long parent
        {
            get; set;

        }
        public string flag
        {
            get; set;
        }
        public string dep { get; set; }

        public string Predec { get; set; }
        public long Priority { get; set; }

        public long mainItemId { get; set; }

        public string Criticaltaskid { get; set; }
        public string RStartDate
        {
            get; set;
        }
        public string REndDate
        {
            get; set;
        }
        public int RDuration { get; set; }
    }
    public class Task
    {
        public string ProjectId { get; set; }
        public long id { get; set; }
        public int locationId { get; set; }
        public string text { get; set; }
        public int mainItemId { get; set; }
        public string name { get; set; }
        public string subitem { get; set; }
        public string subsubitem { get; set; }
        public string boq { get; set; }
        public string task { get; set; }
        public string unit { get; set; }
        public decimal qty { get; set; }
        public decimal urate { get; set; }
        public decimal tcost { get; set; }
        public decimal progress { get; set; }
        public string start_date { get; set; }
        public string end_date { get; set; }
        public decimal Duration { get; set; }
        public string dep { get; set; }
        public string Predec { get; set; }
        public string taskId { get; set; }


        public int step { get; set; }
        public long parent { get; set; }

        public string boqrefId { get; set; }
        public string Workdonedate { get; set; }
        public decimal wcost { get; set; }

        public string RStartDate
        {
            get; set;
        }
        public string REndDate
        {
            get; set;
        }
        public string flag
        {
            get; set;
        }
        public string type { get; set; }

        public long Criticaltaskid { get; set; }

        public long Priority { get; set; }
        public decimal Slack { get; set; }
        public decimal RDuration { get; set; }
        public decimal HDuration { get; set; }

        public string ReviseType { get; set; }
        

    }
    public class links
    {
        public long id { get; set; }
        public long source { get; set; }
        public long target { get; set; }
        public string type { get; set; }
        public string color { get; set; }
    }

    public class boqtasklist
    {
        public List<BOQTASK>  boqlistpro { get; set; }
    }
    

        public class BOQTASK
    {
        public long BOQId { get; set; }
        public string MainItem { get; set; }
        public string SubItem { get; set; }
        public string SubSubItem { get; set; }
        public decimal CompletedPer { get; set; }
        public decimal WorkdonePer { get; set; }
        public string WorkdoneType { get; set; }
    }
    public class BOQREV
    {
        public long BOQId { get; set; }
        public string MainItem { get; set; }
        public string SubItem { get; set; }
        public string SubSubItem { get; set; }        
        public decimal WorkdonePer { get; set; }
        public string start_date { get; set; }
        public string end_date { get; set; }
        public string revice_start_date { get; set; }
        public string revice_end_date { get; set; }
        public string ftype { get; set; }
    }
}