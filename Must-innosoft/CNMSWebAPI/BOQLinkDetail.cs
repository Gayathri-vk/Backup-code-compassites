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
    
    public partial class BOQLinkDetail
    {
        public long BoqLinkId { get; set; }
        public Nullable<long> BOQId { get; set; }
        public Nullable<long> ProjectId { get; set; }
        public string TaskId { get; set; }
        public string SourceId { get; set; }
        public string TargetId { get; set; }
        public Nullable<int> LinkType { get; set; }
        public string Mcolor { get; set; }
        public string Flag { get; set; }
    }
}