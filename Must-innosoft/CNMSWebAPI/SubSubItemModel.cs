using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CNMSWebAPI.Models
{
    public class SubSubItemModel
    {
        public long SubSubItemId { get; set; }
        public long SubItemId { get; set; }
        public string SubSubItemName { get; set; }
        public string SubSubItemDescription { get; set; }
        public int Status { get; set; }
    }
}