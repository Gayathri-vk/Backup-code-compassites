using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CNMSWebAPI.Models
{
    public class SubItemModel
    {
        public long MainItemId { get; set; }
        public long SubItemId { get; set; }
        public string SubItemName { get; set; }
        public string SubItemDescription { get; set; }
        public int Status { get; set; }
    }
}