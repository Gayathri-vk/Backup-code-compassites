using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CNMSWebAPI.Models
{
    public class ProjectModel
    {
        public long ProjectId { get; set; }
        public long ClientId { get; set; }
        public string ProjectName { get; set; }
        public string ContactNo { get; set; }
        public string ProjectIncharge { get; set; }
        public string ProjectLocation { get; set; }
        
        public string EmailId { get; set; }
        public DateTime Start_Date { get; set; }
        public DateTime End_Date { get; set; }
        public string ProjectDuration { get; set; }
        public string UserId { get; set; }
        public int Status { get; set; }
        public int Fromday { get; set; }
        public int Today { get; set; }
        public int Fromtime { get; set; }
        public int Totime { get; set; }

    }
}