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
    
    public partial class SupplierMaster
    {
        public long SupplierId { get; set; }
        public long ClientId { get; set; }
        public string Type { get; set; }
        public string SupplierName { get; set; }
        public string SupplierAddress { get; set; }
        public string ContactPerson { get; set; }
        public string ContactNo { get; set; }
        public string EmailId { get; set; }
        public Nullable<System.DateTime> Modfied_Date { get; set; }
        public Nullable<int> Status { get; set; }
    
        public virtual Client Client { get; set; }
    }
}
