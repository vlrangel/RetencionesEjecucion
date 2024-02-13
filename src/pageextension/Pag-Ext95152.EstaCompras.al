/// <summary>
/// PageExtension EstaCompras (ID 90168) extends Record Purchase Statistics.
/// </summary>
pageextension 95152 EstaCompras extends "Purchase Statistics"
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
