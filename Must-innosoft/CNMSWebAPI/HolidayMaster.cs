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
    
    public partial class HolidayMaster
    {
        public long HId { get; set; }
        public long ClientId { get; set; }
        public string HolidayName { get; set; }
        public Nullable<System.DateTime> HolidayDate { get; set; }
        public string Status { get; set; }
    
        public virtual Client Client { get; set; }
    }
}