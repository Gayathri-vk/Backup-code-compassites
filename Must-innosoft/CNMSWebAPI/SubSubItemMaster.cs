//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CNMSDataAccess
{
    using System;
    using System.Collections.Generic;
    
    public partial class SubSubItemMaster
    {
        public long SubSubItemId { get; set; }
        public long SubItemId { get; set; }
        public string SubSubItemName { get; set; }
        public string SubSubItemDescription { get; set; }
        public Nullable<int> Status { get; set; }
    
        public virtual SubItemMaster SubItemMaster { get; set; }
        public virtual SubSubItemMaster SubSubItemMaster1 { get; set; }
        public virtual SubSubItemMaster SubSubItemMaster2 { get; set; }
    }
}
