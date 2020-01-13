using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CNMSWebAPI.Models
{
    public class LocationModel
    {
        public long LocationId { get; set; }
        public int Status { get; set; }
        public string LocationName { get; set; }
    }
}