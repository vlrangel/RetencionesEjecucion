/// <summary>
/// PageExtension "Page_Navigate" (ID 90150) extends Record Navigate.
/// </summary>
pageextension 95150 Page_Navigate extends Navigate
{
    trigger OnOpenPage()
    var
        Ret: Record "Mov. retención de pagos";
    begin
        if Ret.ReadPermission() then begin
            Ret.Reset();
            Ret.SetFilter("Document No.", DocNoFilter);
            //Ret.SetFilter("No.",ContactNo);
            Ret.SetFilter("External Document No.", ExtDocNo);
            If Rec.FindLast() then Rec."Entry No." := Rec."Entry No." + 1;
            InsertIntoDocEntry(Rec, DATABASE::"Mov. retención de pagos", 'Retenciones', Ret.Count);
        end;
    End;

}