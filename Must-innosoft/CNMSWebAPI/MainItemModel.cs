using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CNMSWebAPI.Models
{
    public class MainItemModel
    {
        public long MainItemId { get; set; }
        public string MainItemName { get; set; }
        public string MainItemDescription { get; set; }
        public int Status { get; set; }

    }
}