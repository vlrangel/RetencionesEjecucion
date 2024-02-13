/// <summary>
/// PageExtension EstadisticasVenta (ID 95169) extends Record Sales Statistics.
/// </summary>
pageextension 95169 EstadisticasVenta extends "Sales Statistics"
{
    layout
    {
        addbefore(VATAmount)
        {
            field("Retención (Be) Total"; Rec."Importe retención (BE)")
            {
                ApplicationArea = All;
            }
            field("Retención (Irpf) Total"; Rec."Importe retención (IRPF)")
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.Calcfields("Importe retención (BE)", "Importe retención (IRPF)");
    End;
}
