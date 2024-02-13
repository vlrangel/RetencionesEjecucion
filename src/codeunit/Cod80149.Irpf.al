/// <summary>
/// Codeunit "I.r.p.f" (ID 7001146).
/// </summary>
Codeunit 80149 "Irpf"
{


    Permissions = tabledata 17 = rimd;

    var
        ErrorRefCat: Label 'Debe informar la referencia catastral del inmueble SII';

    PROCEDURE ReleaseVendorRetention(VAR RetencionEntry: Record "Mov. retención de pagos"; ReleaseDate: Date);
    VAR
        lWindow: Dialog;
        RetentionGroup: Record "Grupo de retención de pagos";
        GenJnlLine: Record 81;
        RecSource: Record 242;
        GenJnlPostLine: Codeunit 12;
        //"---": Integer;
        CduDimensionManagement: Codeunit 408;
        CduSplitVendorDoc: Codeunit 7000005;
        RecMovProveedor: Record 25;
        RecMovProveedor2: Record 25;
        locrecFormapago: Record 289;
        i: Integer;
        RecPurchHeaderTmp: Record 38 TEMPORARY;
        GLEntryNo: Integer;
    BEGIN

        // RecReten2.RESET;
        // RecReten2.COPY(MovRetencion);

        IF RetencionEntry."Retention Type" <> RetencionEntry."Retention Type"::"Good Execution" THEN
            ERROR('Solo se pueden liberar retenciones de buena ejecución.');

        IF NOT RetencionEntry.Open THEN
            ERROR('Solo se pueden liberar retenciones abiertas.');

        RetentionGroup.GET(RetencionEntry."Retention Group Code");


        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := ReleaseDate;
        GenJnlLine."Document No." := RetencionEntry."Document No.";
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", RetencionEntry."No.");
        GenJnlLine.VALIDATE("Retention IRPF", TRUE);
        GenJnlLine."Currency Code" := RetencionEntry."Currency Code";
        GenJnlLine.VALIDATE(Amount, -RetencionEntry.Amount);
        // GenJnlLine."Shortcut Dimension 1 Code" := RetencionEntry."Global Dimension 1 Code";
        // GenJnlLine."Shortcut Dimension 2 Code" := RetencionEntry."Global Dimension 2 Code";
        RecSource.GET;
        // GenJnlLine."Source Code" := RecSource."Liberacion de retenciones";
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Due Date" := RetencionEntry."Due Date";
        GenJnlLine."Bill-to/Pay-to No." := RetencionEntry."No.";
        // GenJnlLine."Tipo retencion" := RecLinDiaGen."Tipo retencion"::"B.E.";
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine.VALIDATE("Bal. Account No.", RetentionGroup."Account No.");
        GenJnlLine.VALIDATE("Retention IRPF", TRUE);

        GenJnlLine."Document Date" := RetencionEntry."Document Date";
        GenJnlLine."External Document No." := RetencionEntry."External Document No.";
        // GenJnlLine."Base retencion" := RetencionEntry.Amount; // Sin IVA
        // GenJnlLine."Base retencion (DL)" := RetencionEntry."Amount (LCY)";

        locrecFormapago.GET(GenJnlLine."Payment Method Code");
        IF locrecFormapago."Create Bills" THEN BEGIN
            CLEAR(RecMovProveedor);
            RecMovProveedor.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
            RecMovProveedor.SETRANGE("Vendor No.", RetencionEntry."No.");
            RecMovProveedor.SETRANGE("Document No.", RetencionEntry."Document No.");
            RecMovProveedor.SETFILTER("Bill No.", 'R*');
            IF RecMovProveedor.FINDLAST THEN
                GenJnlLine."Bill No." := INCSTR(RecMovProveedor."Bill No.")
            ELSE
                GenJnlLine."Bill No." := 'R1';
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Bill;
        END;

        // GenJnlLine."Shortcut Dimension 1 Code" := RetencionEntry."Global Dimension 1 Code";
        // GenJnlLine."Shortcut Dimension 2 Code" := RetencionEntry."Global Dimension 2 Code";
        GenJnlLine.Description := 'LIB. ' + COPYSTR(RetencionEntry.Description, 1, 45);
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
        GenJnlLine."Source No." := RecMovProveedor."Vendor No.";

        //RecLinDiaGen."Dimension Set ID" := MovRetencion."Dimension Set ID";
        // CduFunBM.CombinedDimensionSetID(RecLinDiaGen."Dimension Set ID", MovRetencion."Dimension Set ID", RecLinDiaGen."Shortcut Dimension 1 Code", RecLinDiaGen."Shortcut Dimension 2 Code");
        // GLEntryNo := CduRegDiaGen.RunWithCheck(RecLinDiaGen);

        GenJnlPostLine.RunWithCheck(GenJnlLine);

        RetencionEntry.Open := FALSE;
        RetencionEntry."Release Date" := ReleaseDate;
        RetencionEntry.MODIFY;
    END;

    PROCEDURE ReleaseCustomerRetention(VAR RetencionEntry: Record "Mov. retención de pagos"; ReleaseDate: Date);
    VAR
        lWindow: Dialog;
        RetentionGroup: Record "Grupo de retención de pagos";
        GenJnlLine: Record 81;
        RecSource: Record 242;
        GenJnlPostLine: Codeunit 12;
        "---": Integer;
        CduDimensionManagement: Codeunit 408;
        CduSplitCustomerDoc: Codeunit 7000005;
        RecMovCliente: Record 21;
        RecMovCliente2: Record 21;
        locrecFormapago: Record 289;
        i: Integer;
        RecPurchHeaderTmp: Record 38 TEMPORARY;
        GLEntryNo: Integer;
    BEGIN

        // RecReten2.RESET;
        // RecReten2.COPY(MovRetencion);

        IF RetencionEntry."Retention Type" <> RetencionEntry."Retention Type"::"Good Execution" THEN
            ERROR('Solo se pueden liberar retenciones de buena ejecución.');

        IF NOT RetencionEntry.Open THEN
            ERROR('Solo se pueden liberar retenciones abiertas.');

        RetentionGroup.GET(RetencionEntry."Retention Group Code");


        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := ReleaseDate;
        GenJnlLine."Document No." := RetencionEntry."Document No.";
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
        GenJnlLine.VALIDATE("Account No.", RetencionEntry."No.");
        GenJnlLine.VALIDATE("Retention IRPF", TRUE);
        GenJnlLine."Currency Code" := RetencionEntry."Currency Code";
        GenJnlLine.VALIDATE(Amount, RetencionEntry.Amount);
        // GenJnlLine."Shortcut Dimension 1 Code" := RetencionEntry."Global Dimension 1 Code";
        // GenJnlLine."Shortcut Dimension 2 Code" := RetencionEntry."Global Dimension 2 Code";
        RecSource.GET;
        // GenJnlLine."Source Code" := RecSource."Liberacion de retenciones";
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Due Date" := RetencionEntry."Due Date";
        GenJnlLine."Bill-to/Pay-to No." := RetencionEntry."No.";
        // GenJnlLine."Tipo retencion" := RecLinDiaGen."Tipo retencion"::"B.E.";
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine.VALIDATE("Bal. Account No.", RetentionGroup."Account No.");
        GenJnlLine.VALIDATE("Retention IRPF", TRUE);

        GenJnlLine."Document Date" := RetencionEntry."Document Date";
        GenJnlLine."External Document No." := RetencionEntry."External Document No.";
        // GenJnlLine."Base retencion" := RetencionEntry.Amount; // Sin IVA
        // GenJnlLine."Base retencion (DL)" := RetencionEntry."Amount (LCY)";

        locrecFormapago.GET(GenJnlLine."Payment Method Code");
        IF locrecFormapago."Create Bills" THEN BEGIN
            CLEAR(RecMovCliente);
            RecMovCliente.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
            RecMovCliente.SETRANGE("Customer No.", RetencionEntry."No.");
            RecMovCliente.SETRANGE("Document No.", RetencionEntry."Document No.");
            RecMovCliente.SETFILTER("Bill No.", 'R*');
            IF RecMovCliente.FINDLAST THEN
                GenJnlLine."Bill No." := INCSTR(RecMovCliente."Bill No.")
            ELSE
                GenJnlLine."Bill No." := 'R1';
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Bill;
        END;

        // GenJnlLine."Shortcut Dimension 1 Code" := RetencionEntry."Global Dimension 1 Code";
        // GenJnlLine."Shortcut Dimension 2 Code" := RetencionEntry."Global Dimension 2 Code";
        GenJnlLine.Description := 'LIB. ' + COPYSTR(RetencionEntry.Description, 1, 45);
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source No." := RecMovCliente."Customer No.";

        //RecLinDiaGen."Dimension Set ID" := MovRetencion."Dimension Set ID";
        // CduFunBM.CombinedDimensionSetID(RecLinDiaGen."Dimension Set ID", MovRetencion."Dimension Set ID", RecLinDiaGen."Shortcut Dimension 1 Code", RecLinDiaGen."Shortcut Dimension 2 Code");
        // GLEntryNo := CduRegDiaGen.RunWithCheck(RecLinDiaGen);

        GenJnlPostLine.RunWithCheck(GenJnlLine);

        RetencionEntry.Open := FALSE;
        RetencionEntry."Release Date" := ReleaseDate;
        RetencionEntry.MODIFY;
    END;

    internal procedure CambiarRetentionDate(var Rec: Record "Mov. retención de pagos"; ReleaseDate: Date)
    begin
        Rec."Document Date" := ReleaseDate;
        Rec."Posting Date" := ReleaseDate;
        Rec.Modify();
    end;


    #region Irpf
    [EventSubscriber(ObjectType::Codeunit, 826, 'OnBeforeInitGenJnlLineAmountFieldsFromTotalLines', '', false, false)]

    local procedure OnBeforeInitGenJnlLineAmountFieldsFromTotalLines(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; var IsHandled: Boolean)
    var
        BaseRetentionIRPF: Decimal;
        TotalRetentionIRPF: Decimal;
        PaymentsRetentionGroup: Record "Grupo de retención de pagos";
        RetEntryPurchLine: Record 39;
    begin
        IsHandled := True;
        RetEntryPurchLine.RESET;
        RetEntryPurchLine.SETRANGE(RetEntryPurchLine."Document Type", PurchHeader."Document Type");
        RetEntryPurchLine.SETRANGE(RetEntryPurchLine."Document No.", PurchHeader."No.");
        IF RetEntryPurchLine.FINDFIRST THEN
            REPEAT
                TotalRetentionIRPF += RetEntryPurchLine."Importe retención (IRPF)";
                IF RetEntryPurchLine."Importe retención (IRPF)" <> 0 THEN
                    BaseRetentionIRPF += RetEntryPurchLine."Line Amount";
            UNTIL RetEntryPurchLine.NEXT = 0;
        IF (TotalRetentionIRPF = 0) THEN begin
            IsHandled := false;
            exit;
        end;
        If PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" Then begin
            TotalRetentionIRPF := -TotalRetentionIRPF;
            BaseRetentionIRPF := -BaseRetentionIRPF;

        end;
        //with GenJnlLine do begin
        GenJnlLine.Amount := -TotalPurchLine."Amount Including VAT" + TotalRetentionIRPF;
        GenJnlLine."Source Currency Amount" := -TotalPurchLine."Amount Including VAT" + TotalRetentionIRPF;
        GenJnlLine."Amount (LCY)" := -TotalPurchLineLCY."Amount Including VAT" + TotalRetentionIRPF;
        GenJnlLine."Sales/Purch. (LCY)" := -TotalPurchLineLCY.Amount + BaseRetentionIRPF;
        GenJnlLine."Inv. Discount (LCY)" := -TotalPurchLineLCY."Inv. Discount Amount";
        //end;
    end;


    [EventSubscriber(ObjectType::Codeunit, 826, 'OnPostLedgerEntryOnAfterGenJnlPostLine', '', false, false)]


    local procedure OnPostLedgerEntryOnAfterGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; SuppressCommit: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        BaseRetentionGE: Decimal;
        BaseRetentionIRPF: Decimal;
        TotalRetentionGE: Decimal;
        TotalRetentionIRPF: Decimal;
        PaymentsRetentionGroup: Record "Grupo de retención de pagos";
        RetEntryPurchLine: Record 39;
        GLAccountGE: Code[20];
        GLAccountIRPF: Code[20];
        RetEntry: Record "Mov. retención de pagos";
        RetEntryNewId: Integer;
        GenJnlLineDocType: Enum "Gen. Journal Document Type";
        DocNo: Code[20];
        ExtDocNo: Code[35];
        SourceCode: Code[10];
        Lines: Record "Purchase Line";
    //GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"

    BEGIN

        IF (PurchHeader."Código grupo retención (BE)" = '') And (PurchHeader."Código grupo retención (IRPF)" = '') Then exit;
        TotalRetentionGE := 0;
        TotalRetentionIRPF := 0;
        BaseRetentionGE := 0;
        BaseRetentionIRPF := 0;
        GenJnlLineDocType := GenJnlLine."Document Type";
        DocNo := GenJnlLine."Document No.";
        ExtDocNo := GenJnlLine."External Document No.";
        SourceCode := GenJnlLine."Source Code";
        // BE
        IF PurchHeader."Código grupo retención (BE)" <> '' THEN
            IF PaymentsRetentionGroup.GET(PurchHeader."Código grupo retención (BE)") THEN BEGIN
                If PaymentsRetentionGroup."Referencia Cat. Obligatoria" then begin
                    Lines.Setrange("Document Type", PurchHeader."Document Type");
                    Lines.Setrange("Document No.", PurchHeader."No.");
                    Lines.SETRANGE("Ref. catastral inmueble SII", '');
                    Lines.Setfilter("% Retención (Be)", '<>%1', 0);
                    If not Lines.IsEmpty then Error(ErrorRefCat);

                end;
                PaymentsRetentionGroup.TESTFIELD(PaymentsRetentionGroup."Account No.");
                GLAccountGE := PaymentsRetentionGroup."Account No.";
            END;

        // IRPF
        IF PurchHeader."Código grupo retención (IRPF)" <> '' THEN
            IF PaymentsRetentionGroup.GET(PurchHeader."Código grupo retención (IRPF)") THEN BEGIN
                If PaymentsRetentionGroup."Referencia Cat. Obligatoria" then begin
                    Lines.Setrange("Document Type", PurchHeader."Document Type");
                    Lines.Setrange("Document No.", PurchHeader."No.");
                    Lines.SETRANGE("Ref. catastral inmueble SII", '');
                    Lines.Setfilter("% retención (Irpf)", '<>%1', 0);
                    If not Lines.IsEmpty then Error(ErrorRefCat);

                end;
                PaymentsRetentionGroup.TESTFIELD(PaymentsRetentionGroup."Account No.");
                GLAccountIRPF := PaymentsRetentionGroup."Account No.";
            END;


        RetEntryPurchLine.RESET;
        RetEntryPurchLine.SETRANGE(RetEntryPurchLine."Document Type", PurchHeader."Document Type");
        RetEntryPurchLine.SETRANGE(RetEntryPurchLine."Document No.", PurchHeader."No.");
        IF RetEntryPurchLine.FINDFIRST THEN
            REPEAT
                TotalRetentionGE += RetEntryPurchLine."Importe retención (BE)";
                IF RetEntryPurchLine."Importe retención (BE)" <> 0 THEN
                    BaseRetentionGE += RetEntryPurchLine."Line Amount";
                //
                TotalRetentionIRPF += RetEntryPurchLine."Importe retención (IRPF)";
                IF RetEntryPurchLine."Importe retención (IRPF)" <> 0 THEN
                    BaseRetentionIRPF += RetEntryPurchLine."Line Amount";
            UNTIL RetEntryPurchLine.NEXT = 0;

        // BE
        IF (TotalRetentionGE <> 0) AND (GLAccountGE <> '') THEN begin
            //WITH GenJnlLine DO BEGIN
            GenJnlLine.InitNewLine(
            PurchHeader."Posting Date", PurchHeader."Document Date", PurchHeader."Posting Date", PurchHeader."Posting Description",
            PurchHeader."Shortcut Dimension 1 Code", PurchHeader."Shortcut Dimension 2 Code",
            PurchHeader."Dimension Set ID", PurchHeader."Reason Code");
            GenJnlLine.CopyDocumentFields(GenJnlLineDocType, DocNo, ExtDocNo, SourceCode, '');
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
            GenJnlLine."Account No." := PurchHeader."Pay-to Vendor No.";
            GenJnlLine.CopyFromPurchHeader(PurchHeader);
            GenJnlLine.SetCurrencyFactor(PurchHeader."Currency Code", PurchHeader."Currency Factor");
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.CopyFromPurchHeaderApplyTo(PurchHeader);
            GenJnlLine."Applies-to Bill No." := PurchHeader."Applies-to Bill No.";
            GenJnlLine.CopyFromPurchHeaderPayment(PurchHeader);
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN BEGIN
                GenJnlLine.Amount := TotalRetentionGE;
                GenJnlLine."Source Currency Amount" := TotalRetentionGE;
            END;
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine.Amount := -TotalRetentionGE;
                GenJnlLine."Source Currency Amount" := -TotalRetentionGE;
            END;
            GenJnlLine."ID Type" := PurchHeader."ID Type";
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN BEGIN
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := DocNo;
            END;
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Credit Memo";
                GenJnlLine."Applies-to Doc. No." := DocNo;
            END;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := GLAccountGE;
            GenJnlLine."Retention IRPF" := TRUE;
            GenJnlLine."Pmt. Discount Date" := 0D;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            //
            RetEntry.RESET;
            RetEntryNewId := 1;
            IF RetEntry.FINDLAST THEN
                RetEntryNewId := RetEntry."Entry No." + 1;
            RetEntry.INIT;
            RetEntry."Entry No." := RetEntryNewId;
            RetEntry.Type := RetEntry.Type::Vendor;
            RetEntry."No." := PurchHeader."Pay-to Vendor No.";
            if PurchHeader."Código grupo retención (BE)" <> '' then begin
                PaymentsRetentionGroup.GET(PurchHeader."Código grupo retención (BE)");
                RetEntry."Retention Group Code" := PurchHeader."Código grupo retención (BE)";
                RetEntry."Retention Type" := PaymentsRetentionGroup."Retention Type";
                RetEntry."Retention Base" := PaymentsRetentionGroup."Retention Base";
            end;
            RetEntry."Retention Action" := RetEntry."Retention Action"::"Payment Hold";
            RetEntry.Description := 'Retención buena ejecución';
            RetEntry."Posting Date" := PurchHeader."Posting Date";
            RetEntry."Due Date" := CALCDATE(PaymentsRetentionGroup."Warranty Period", PurchHeader."Due Date");
            RetEntry."Document Date" := PurchHeader."Document Date";
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN
                RetEntry."Document Type" := RetEntry."Document Type"::Invoice;
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN
                RetEntry."Document Type" := RetEntry."Document Type"::"Credit Memo";
            RetEntry."Document No." := DocNo;
            RetEntry."External Document No." := ExtDocNo;
            RetEntry."Currency Code" := GenJnlLine."Currency Code";
            RetEntry."Retention Amount Base" := ABS(BaseRetentionGE);
            RetEntry."Retention Amount Base (LCY)" := ABS(BaseRetentionGE);
            RetEntry.Amount := ABS(GenJnlLine.Amount);
            RetEntry."Amount (LCY)" := ABS(GenJnlLine."Amount (LCY)");
            RetEntry."Referencia Catastral" := TotalPurchLine."Ref. catastral inmueble SII";
            RetEntry.Open := TRUE;
            RetEntry.INSERT;
        END;

        // IRPF
        IF (TotalRetentionIRPF <> 0) AND (GLAccountIRPF <> '') THEN begin
            // WITH GenJnlLine DO BEGIN
            GenJnlLine.InitNewLine(
                PurchHeader."Posting Date", PurchHeader."Document Date", PurchHeader."Posting Date", PurchHeader."Posting Description",
                PurchHeader."Shortcut Dimension 1 Code", PurchHeader."Shortcut Dimension 2 Code",
                PurchHeader."Dimension Set ID", PurchHeader."Reason Code");
            GenJnlLine.CopyDocumentFields(GenJnlLineDocType, DocNo, ExtDocNo, SourceCode, '');
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := GlAccountIRPF;
            GenJnlLine.CopyFromPurchHeader(PurchHeader);
            GenJnlLine.SetCurrencyFactor(PurchHeader."Currency Code", PurchHeader."Currency Factor");
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.CopyFromPurchHeaderApplyTo(PurchHeader);
            //"Applies-to Bill No." := PurchHeader."Applies-to Bill No.";
            GenJnlLine.CopyFromPurchHeaderPayment(PurchHeader);
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN BEGIN
                GenJnlLine.Amount := -TotalRetentionIRPF;
                GenJnlLine."Source Currency Amount" := -TotalRetentionIRPF;
            END;
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine.Amount := TotalRetentionIRPF;
                GenJnlLine."Source Currency Amount" := TotalRetentionIRPF;
            END;
            GenJnlLine."ID Type" := PurchHeader."ID Type";
            // IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN BEGIN
            //     "Applies-to Doc. Type" := "Applies-to Doc. Type"::Invoice;
            //     "Applies-to Doc. No." := DocNo;
            // END;
            // IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN BEGIN
            //     "Applies-to Doc. Type" := "Applies-to Doc. Type"::"Credit Memo";
            //     "Applies-to Doc. No." := DocNo;
            // END;
            GenJnlLine."Document Type" := GenJnlLineDocType;
            // "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
            // "Bal. Account No." := GLAccountIRPF;
            GenJnlLine."Retention IRPF" := TRUE;
            GenJnlLine."Pmt. Discount Date" := 0D;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            //
            RetEntry.RESET;
            RetEntryNewId := 1;
            IF RetEntry.FINDLAST THEN
                RetEntryNewId := RetEntry."Entry No." + 1;
            RetEntry.INIT;
            RetEntry."Entry No." := RetEntryNewId;
            RetEntry.Type := RetEntry.Type::Vendor;
            RetEntry."No." := PurchHeader."Pay-to Vendor No.";
            If PaymentsRetentionGroup.GET(PurchHeader."Código grupo retención (IRPF)") Then begin
                RetEntry."Retention Group Code" := PurchHeader."Código grupo retención (IRPF)";
                RetEntry."Retention Type" := PaymentsRetentionGroup."Retention Type";
                RetEntry."Retention Base" := PaymentsRetentionGroup."Retention Base";
            end;
            RetEntry."Retention Action" := RetEntry."Retention Action"::"Payment Hold";
            RetEntry.Description := 'Retención Irpf';
            RetEntry."Posting Date" := PurchHeader."Posting Date";
            RetEntry."Due Date" := CALCDATE(PaymentsRetentionGroup."Warranty Period", PurchHeader."Due Date");
            RetEntry."Document Date" := PurchHeader."Document Date";
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN
                RetEntry."Document Type" := RetEntry."Document Type"::Invoice;
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN
                RetEntry."Document Type" := RetEntry."Document Type"::"Credit Memo";
            RetEntry."Document No." := GenJnlLine."Document No.";
            RetEntry."External Document No." := GenJnlLine."External Document No.";
            RetEntry."Currency Code" := GenJnlLine."Currency Code";
            RetEntry."Retention Amount Base" := ABS(BaseRetentionIRPF);
            RetEntry."Retention Amount Base (LCY)" := ABS(BaseRetentionIRPF);
            RetEntry.Amount := ABS(GenJnlLine.Amount);
            RetEntry."Amount (LCY)" := ABS(GenJnlLine."Amount (LCY)");
            RetEntry."Referencia Catastral" := TotalPurchLine."Ref. catastral inmueble SII";
            RetEntry.Open := TRUE;
            RetEntry.INSERT;
        END;
    END;


    [EventSubscriber(ObjectType::Codeunit, 825, 'OnBeforeInitGenJnlLineAmountFieldsFromTotalLines', '', false, false)]

    local procedure OnBeforeInitGenJnlLineAmountFieldsFromTotalSalesLines(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Sales Header"; var TotalPurchLine: Record "Sales Line"; var TotalPurchLineLCY: Record "Sales Line"; var IsHandled: Boolean)
    var
        BaseRetentionIRPF: Decimal;
        TotalRetentionIRPF: Decimal;
        PaymentsRetentionGroup: Record "Grupo de retención de pagos";
        RetEntryPurchLine: Record 37;
    begin
        IsHandled := True;
        RetEntryPurchLine.RESET;
        RetEntryPurchLine.SETRANGE(RetEntryPurchLine."Document Type", PurchHeader."Document Type");
        RetEntryPurchLine.SETRANGE(RetEntryPurchLine."Document No.", PurchHeader."No.");
        IF RetEntryPurchLine.FINDFIRST THEN
            REPEAT
                TotalRetentionIRPF += RetEntryPurchLine."Importe retención (IRPF)";
                IF RetEntryPurchLine."Importe retención (IRPF)" <> 0 THEN
                    BaseRetentionIRPF += RetEntryPurchLine."Line Amount";
            UNTIL RetEntryPurchLine.NEXT = 0;
        IF (TotalRetentionIRPF = 0) THEN begin
            IsHandled := false;
            exit;
        end;
        If PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" Then begin
            TotalRetentionIRPF := -TotalRetentionIRPF;
            BaseRetentionIRPF := -BaseRetentionIRPF;

        end;
        //with GenJnlLine do begin
        GenJnlLine.Amount := -TotalPurchLine."Amount Including VAT" + (TotalRetentionIRPF) * -1;
        GenJnlLine."Source Currency Amount" := -TotalPurchLine."Amount Including VAT" + (TotalRetentionIRPF) * -1;
        GenJnlLine."Amount (LCY)" := -TotalPurchLineLCY."Amount Including VAT" + (TotalRetentionIRPF) * -1;
        GenJnlLine."Sales/Purch. (LCY)" := -TotalPurchLineLCY.Amount + BaseRetentionIRPF;
        GenJnlLine."Inv. Discount (LCY)" := -TotalPurchLineLCY."Inv. Discount Amount";
        //end;
    end;


    [EventSubscriber(ObjectType::Codeunit, 825, 'OnPostLedgerEntryOnAfterGenJnlPostLine', '', false, false)]

    local procedure OnPostLedgerEntryOnAfterGenJnlPostLineCust(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; PreviewMode: Boolean; SuppressCommit: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        BaseRetentionGE: Decimal;
        BaseRetentionIRPF: Decimal;
        TotalRetentionGE: Decimal;
        TotalRetentionIRPF: Decimal;
        PaymentsRetentionGroup: Record "Grupo de retención de pagos";
        RetEntrySalesLine: Record 37;
        GLAccountGE: Code[20];
        GLAccountIRPF: Code[20];
        RetEntry: Record "Mov. retención de pagos";
        RetEntryNewId: Integer;
        GenJnlLineDocType: Enum "Gen. Journal Document Type";
        DocNo: Code[20];
        ExtDocNo: Code[35];
        SourceCode: Code[10];
    //GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"

    BEGIN
        IF (SalesHeader."Código grupo retención (BE)" = '') And (SalesHeader."Código grupo retención (IRPF)" = '') Then exit;

        TotalRetentionGE := 0;
        TotalRetentionIRPF := 0;
        BaseRetentionGE := 0;
        BaseRetentionIRPF := 0;
        GenJnlLineDocType := GenJnlLine."Document Type";
        DocNo := GenJnlLine."Document No.";
        ExtDocNo := GenJnlLine."External Document No.";
        SourceCode := GenJnlLine."Source Code";
        // BE
        IF SalesHeader."Código grupo retención (BE)" <> '' THEN
            IF PaymentsRetentionGroup.GET(SalesHeader."Código grupo retención (BE)") THEN BEGIN
                PaymentsRetentionGroup.TESTFIELD(PaymentsRetentionGroup."Account No.");
                GLAccountGE := PaymentsRetentionGroup."Account No.";
            END;

        // IRPF
        IF SalesHeader."Código grupo retención (IRPF)" <> '' THEN
            IF PaymentsRetentionGroup.GET(SalesHeader."Código grupo retención (IRPF)") THEN BEGIN
                PaymentsRetentionGroup.TESTFIELD(PaymentsRetentionGroup."Account No.");
                GLAccountIRPF := PaymentsRetentionGroup."Account No.";
            END;


        RetEntrySalesLine.RESET;
        RetEntrySalesLine.SETRANGE(RetEntrySalesLine."Document Type", SalesHeader."Document Type");
        RetEntrySalesLine.SETRANGE(RetEntrySalesLine."Document No.", SalesHeader."No.");
        IF RetEntrySalesLine.FINDFIRST THEN
            REPEAT
                TotalRetentionGE += RetEntrySalesLine."Importe retención (BE)";
                IF RetEntrySalesLine."Importe retención (BE)" <> 0 THEN
                    BaseRetentionGE += RetEntrySalesLine."Line Amount";
                //
                TotalRetentionIRPF += RetEntrySalesLine."Importe retención (IRPF)";
                IF RetEntrySalesLine."Importe retención (IRPF)" <> 0 THEN
                    BaseRetentionIRPF += RetEntrySalesLine."Line Amount";
            UNTIL RetEntrySalesLine.NEXT = 0;

        // BE
        IF (TotalRetentionGE <> 0) AND (GLAccountGE <> '') THEN begin
            //WITH GenJnlLine DO BEGIN
            GenJnlLine.InitNewLine(
            SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."Posting Date", SalesHeader."Posting Description",
            SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code",
            SalesHeader."Dimension Set ID", SalesHeader."Reason Code");
            GenJnlLine.CopyDocumentFields(GenJnlLineDocType, DocNo, ExtDocNo, SourceCode, '');
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
            GenJnlLine."Account No." := SalesHeader."Bill-to Customer No.";
            GenJnlLine.CopyFromSalesHeader(SalesHeader);
            GenJnlLine.SetCurrencyFactor(SalesHeader."Currency Code", SalesHeader."Currency Factor");
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.CopyFromSalesHeaderApplyTo(SalesHeader);
            GenJnlLine."Applies-to Bill No." := SalesHeader."Applies-to Bill No.";
            GenJnlLine.CopyFromSalesHeaderPayment(SalesHeader);
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN BEGIN
                GenJnlLine.Amount := -TotalRetentionGE;
                GenJnlLine."Source Currency Amount" := -TotalRetentionGE;
            END;
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine.Amount := TotalRetentionGE;
                GenJnlLine."Source Currency Amount" := TotalRetentionGE;
            END;
            GenJnlLine."ID Type" := SalesHeader."ID Type";
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN BEGIN
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := DocNo;
            END;
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Credit Memo";
                GenJnlLine."Applies-to Doc. No." := DocNo;
            END;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Payment";
            // if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice Then
            //     "Document Type" := "Document Type"::Invoice;
            // if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" Then
            //     "Document Type" := "Document Type"::"Credit Memo";
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := GLAccountGE;
            GenJnlLine."Retention IRPF" := TRUE;
            GenJnlLine."Pmt. Discount Date" := 0D;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            //
            RetEntry.RESET;
            RetEntryNewId := 1;
            IF RetEntry.FINDLAST THEN
                RetEntryNewId := RetEntry."Entry No." + 1;
            RetEntry.INIT;
            RetEntry."Entry No." := RetEntryNewId;
            RetEntry.Type := RetEntry.Type::Customer;
            RetEntry."No." := SalesHeader."Bill-to Customer No.";
            if SalesHeader."Código grupo retención (BE)" <> '' then begin
                PaymentsRetentionGroup.GET(SalesHeader."Código grupo retención (BE)");
                RetEntry."Retention Group Code" := SalesHeader."Código grupo retención (BE)";
                RetEntry."Retention Type" := PaymentsRetentionGroup."Retention Type";
                RetEntry."Retention Base" := PaymentsRetentionGroup."Retention Base";
            end;
            RetEntry."Retention Action" := RetEntry."Retention Action"::"Payment Hold";
            RetEntry.Description := 'Retención buena ejecución';
            RetEntry."Posting Date" := SalesHeader."Posting Date";
            RetEntry."Due Date" := CALCDATE(PaymentsRetentionGroup."Warranty Period", SalesHeader."Due Date");
            RetEntry."Document Date" := SalesHeader."Document Date";
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN
                RetEntry."Document Type" := RetEntry."Document Type"::Invoice;
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN
                RetEntry."Document Type" := RetEntry."Document Type"::"Credit Memo";
            RetEntry."Document No." := DocNo;
            RetEntry."External Document No." := ExtDocNo;
            RetEntry."Currency Code" := GenJnlLine."Currency Code";
            RetEntry."Retention Amount Base" := -ABS(BaseRetentionGE);
            RetEntry."Retention Amount Base (LCY)" := -ABS(BaseRetentionGE);
            RetEntry.Amount := -ABS(GenJnlLine.Amount);
            RetEntry."Amount (LCY)" := -ABS(GenJnlLine."Amount (LCY)");
            RetEntry.Open := TRUE;
            RetEntry.INSERT;
        END;

        // IRPF
        IF (TotalRetentionIRPF <> 0) AND (GLAccountIRPF <> '') THEN begin
            //WITH GenJnlLine DO BEGIN
            GenJnlLine.InitNewLine(
            SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."Posting Date", SalesHeader."Posting Description",
            SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code",
            SalesHeader."Dimension Set ID", SalesHeader."Reason Code");
            GenJnlLine.CopyDocumentFields(GenJnlLineDocType, DocNo, ExtDocNo, SourceCode, '');
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := GLAccountIRPF;
            GenJnlLine.CopyFromSalesHeader(SalesHeader);
            GenJnlLine.SetCurrencyFactor(SalesHeader."Currency Code", SalesHeader."Currency Factor");
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.CopyFromSalesHeaderApplyTo(SalesHeader);
            //"Applies-to Bill No." := SalesHeader."Applies-to Bill No.";
            GenJnlLine.CopyFromSalesHeaderPayment(SalesHeader);
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN BEGIN
                GenJnlLine.Amount := +TotalRetentionIRPF;
                GenJnlLine."Source Currency Amount" := +TotalRetentionIRPF;
            END;
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine.Amount := -TotalRetentionIRPF;
                GenJnlLine."Source Currency Amount" := -TotalRetentionIRPF;
            END;
            GenJnlLine."ID Type" := SalesHeader."ID Type";
            // IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN BEGIN
            //     "Applies-to Doc. Type" := "Applies-to Doc. Type"::Invoice;
            //     "Applies-to Doc. No." := DocNo;
            // END;
            // IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN BEGIN
            //     "Applies-to Doc. Type" := "Applies-to Doc. Type"::"Credit Memo";
            //     "Applies-to Doc. No." := DocNo;
            // END;
            GenJnlLine."Document Type" := GenJnlLineDocType;
            // if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice Then
            //     "Document Type" := "Document Type"::Invoice;
            // if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" Then
            //     "Document Type" := "Document Type"::"Credit Memo";
            //"Bal. Account Type" := "Bal. Account Type"::"G/L Account";
            //"Bal. Account No." := GLAccountIRPF;
            GenJnlLine."Retention IRPF" := TRUE;
            GenJnlLine."Pmt. Discount Date" := 0D;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            //
            RetEntry.RESET;
            RetEntryNewId := 1;
            IF RetEntry.FINDLAST THEN
                RetEntryNewId := RetEntry."Entry No." + 1;
            RetEntry.INIT;
            RetEntry."Entry No." := RetEntryNewId;
            RetEntry.Type := RetEntry.Type::Customer;
            RetEntry."No." := SalesHeader."Bill-to Customer No.";
            PaymentsRetentionGroup.GET(SalesHeader."Código grupo retención (IRPF)");
            RetEntry."Retention Group Code" := SalesHeader."Código grupo retención (IRPF)";
            RetEntry."Retention Type" := PaymentsRetentionGroup."Retention Type";
            RetEntry."Retention Base" := PaymentsRetentionGroup."Retention Base";
            RetEntry."Retention Action" := RetEntry."Retention Action"::"Payment Hold";
            RetEntry.Description := 'Retención Irpf';
            RetEntry."Posting Date" := SalesHeader."Posting Date";
            RetEntry."Due Date" := CALCDATE(PaymentsRetentionGroup."Warranty Period", SalesHeader."Due Date");
            RetEntry."Document Date" := SalesHeader."Document Date";
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN
                RetEntry."Document Type" := RetEntry."Document Type"::Invoice;
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN
                RetEntry."Document Type" := RetEntry."Document Type"::"Credit Memo";
            RetEntry."Document No." := GenJnlLine."Document No.";
            RetEntry."External Document No." := GenJnlLine."External Document No.";
            RetEntry."Currency Code" := GenJnlLine."Currency Code";
            RetEntry."Retention Amount Base" := ABS(BaseRetentionIRPF);
            RetEntry."Retention Amount Base (LCY)" := ABS(BaseRetentionIRPF);
            RetEntry.Amount := ABS(GenJnlLine.Amount);
            RetEntry."Amount (LCY)" := ABS(GenJnlLine."Amount (LCY)");
            RetEntry.Open := TRUE;
            RetEntry.INSERT;
        END;
    END;
#pragma warning disable AL0432 // TODO: - Revisar en la próxima versión
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeInitGenJnlLineAmountFieldsFromTotalPurchLine', '', false, false)]
#pragma warning restore AL0432 // TODO: - Revisar en la próxima versión
    local procedure OnBeforeInitGenJnlLineAmountFieldsFromTotalPurchLine(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine2: Record "Purchase Line"; var TotalPurchLineLCY2: Record "Purchase Line"; var IsHandled: Boolean)
    var
        BaseRetentionIRPF: Decimal;
        TotalRetentionIRPF: Decimal;
        PaymentsRetentionGroup: Record "Grupo de retención de pagos";
        RetEntryPurchLine: Record 39;
    begin
        IsHandled := True;
        RetEntryPurchLine.RESET;
        RetEntryPurchLine.SETRANGE(RetEntryPurchLine."Document Type", PurchHeader."Document Type");
        RetEntryPurchLine.SETRANGE(RetEntryPurchLine."Document No.", PurchHeader."No.");
        IF RetEntryPurchLine.FINDFIRST THEN
            REPEAT
                TotalRetentionIRPF += RetEntryPurchLine."Importe retención (IRPF)";
                IF RetEntryPurchLine."Importe retención (IRPF)" <> 0 THEN
                    BaseRetentionIRPF += RetEntryPurchLine."Line Amount";
            UNTIL RetEntryPurchLine.NEXT = 0;
        IF (TotalRetentionIRPF = 0) THEN begin
            IsHandled := false;
            exit;
        end;
        If PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" Then begin
            TotalRetentionIRPF := -TotalRetentionIRPF;
            BaseRetentionIRPF := -BaseRetentionIRPF;

        end;
        //with GenJnlLine do begin
        GenJnlLine.Amount := -TotalPurchLine2."Amount Including VAT" + TotalRetentionIRPF;
        GenJnlLine."Source Currency Amount" := -TotalPurchLine2."Amount Including VAT" + TotalRetentionIRPF;
        GenJnlLine."Amount (LCY)" := -TotalPurchLineLCY2."Amount Including VAT" + TotalRetentionIRPF;
        GenJnlLine."Sales/Purch. (LCY)" := -TotalPurchLineLCY2.Amount + BaseRetentionIRPF;
        GenJnlLine."Inv. Discount (LCY)" := -TotalPurchLineLCY2."Inv. Discount Amount";
        //end;
    end;

#pragma warning disable AL0432 // TODO: - Revisar en la próxima versión
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostVendorEntry', '', false, false)]
#pragma warning restore AL0432 // TODO: - Revisar en la próxima versión
    local procedure OnAfterPostVendorEntry(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        BaseRetentionGE: Decimal;
        BaseRetentionIRPF: Decimal;
        TotalRetentionGE: Decimal;
        TotalRetentionIRPF: Decimal;
        PaymentsRetentionGroup: Record "Grupo de retención de pagos";
        RetEntryPurchLine: Record 39;
        GLAccountGE: Code[20];
        GLAccountIRPF: Code[20];
        RetEntry: Record "Mov. retención de pagos";
        RetEntryNewId: Integer;
        GenJnlLineDocType: Enum "Gen. Journal Document Type";
        DocNo: Code[20];
        ExtDocNo: Code[35];
        SourceCode: Code[10];
        Lines: Record "Purchase Line";
    //GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"

    BEGIN

        IF (PurchHeader."Código grupo retención (BE)" = '') And (PurchHeader."Código grupo retención (IRPF)" = '') Then exit;
        TotalRetentionGE := 0;
        TotalRetentionIRPF := 0;
        BaseRetentionGE := 0;
        BaseRetentionIRPF := 0;
        GenJnlLineDocType := GenJnlLine."Document Type";
        DocNo := GenJnlLine."Document No.";
        ExtDocNo := GenJnlLine."External Document No.";
        SourceCode := GenJnlLine."Source Code";
        // BE
        IF PurchHeader."Código grupo retención (BE)" <> '' THEN
            IF PaymentsRetentionGroup.GET(PurchHeader."Código grupo retención (BE)") THEN BEGIN
                If PaymentsRetentionGroup."Referencia Cat. Obligatoria" then begin
                    Lines.Setrange("Document Type", PurchHeader."Document Type");
                    Lines.Setrange("Document No.", PurchHeader."No.");
                    Lines.SETRANGE("Ref. catastral inmueble SII", '');
                    Lines.Setfilter("% retención (Be)", '<>%1', 0);
                    If not Lines.IsEmpty then Error(ErrorRefCat);

                end;
                PaymentsRetentionGroup.TESTFIELD(PaymentsRetentionGroup."Account No.");
                GLAccountGE := PaymentsRetentionGroup."Account No.";
            END;

        // IRPF
        IF PurchHeader."Código grupo retención (IRPF)" <> '' THEN
            IF PaymentsRetentionGroup.GET(PurchHeader."Código grupo retención (IRPF)") THEN BEGIN
                If PaymentsRetentionGroup."Referencia Cat. Obligatoria" then begin
                    Lines.Setrange("Document Type", PurchHeader."Document Type");
                    Lines.Setrange("Document No.", PurchHeader."No.");
                    Lines.SETRANGE("Ref. catastral inmueble SII", '');
                    Lines.Setfilter("% retención (Irpf)", '<>%1', 0);
                    If not Lines.IsEmpty then Error(ErrorRefCat);

                end;
                PaymentsRetentionGroup.TESTFIELD(PaymentsRetentionGroup."Account No.");
                GLAccountIRPF := PaymentsRetentionGroup."Account No.";
            END;


        RetEntryPurchLine.RESET;
        RetEntryPurchLine.SETRANGE(RetEntryPurchLine."Document Type", PurchHeader."Document Type");
        RetEntryPurchLine.SETRANGE(RetEntryPurchLine."Document No.", PurchHeader."No.");
        IF RetEntryPurchLine.FINDFIRST THEN
            REPEAT
                TotalRetentionGE += RetEntryPurchLine."Importe retención (BE)";
                IF RetEntryPurchLine."Importe retención (BE)" <> 0 THEN
                    BaseRetentionGE += RetEntryPurchLine."Line Amount";
                //
                TotalRetentionIRPF += RetEntryPurchLine."Importe retención (IRPF)";
                IF RetEntryPurchLine."Importe retención (IRPF)" <> 0 THEN
                    BaseRetentionIRPF += RetEntryPurchLine."Line Amount";
            UNTIL RetEntryPurchLine.NEXT = 0;

        // BE
        IF (TotalRetentionGE <> 0) AND (GLAccountGE <> '') THEN begin
            //WITH GenJnlLine DO BEGIN
            GenJnlLine.InitNewLine(
            PurchHeader."Posting Date", PurchHeader."Document Date", PurchHeader."VAT Reporting Date", PurchHeader."Posting Description",
            PurchHeader."Shortcut Dimension 1 Code", PurchHeader."Shortcut Dimension 2 Code",
            PurchHeader."Dimension Set ID", PurchHeader."Reason Code");
            GenJnlLine.CopyDocumentFields(GenJnlLineDocType, DocNo, ExtDocNo, SourceCode, '');
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
            GenJnlLine."Account No." := PurchHeader."Pay-to Vendor No.";
            GenJnlLine.CopyFromPurchHeader(PurchHeader);
            GenJnlLine.SetCurrencyFactor(PurchHeader."Currency Code", PurchHeader."Currency Factor");
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.CopyFromPurchHeaderApplyTo(PurchHeader);
            GenJnlLine."Applies-to Bill No." := PurchHeader."Applies-to Bill No.";
            GenJnlLine.CopyFromPurchHeaderPayment(PurchHeader);
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN BEGIN
                GenJnlLine.Amount := TotalRetentionGE;
                GenJnlLine."Source Currency Amount" := TotalRetentionGE;
            END;
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine.Amount := -TotalRetentionGE;
                GenJnlLine."Source Currency Amount" := -TotalRetentionGE;
            END;
            GenJnlLine."ID Type" := PurchHeader."ID Type";
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN BEGIN
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := DocNo;
            END;
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Credit Memo";
                GenJnlLine."Applies-to Doc. No." := DocNo;
            END;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := GLAccountGE;
            GenJnlLine."Retention IRPF" := TRUE;

            GenJnlLine."Pmt. Discount Date" := 0D;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            //
            RetEntry.RESET;
            RetEntryNewId := 1;
            IF RetEntry.FINDLAST THEN
                RetEntryNewId := RetEntry."Entry No." + 1;
            RetEntry.INIT;
            RetEntry."Entry No." := RetEntryNewId;
            RetEntry.Type := RetEntry.Type::Vendor;
            RetEntry."No." := PurchHeader."Pay-to Vendor No.";
            if PurchHeader."Código grupo retención (BE)" <> '' then begin
                PaymentsRetentionGroup.GET(PurchHeader."Código grupo retención (BE)");
                RetEntry."Retention Group Code" := PurchHeader."Código grupo retención (BE)";
                RetEntry."Retention Type" := PaymentsRetentionGroup."Retention Type";
                RetEntry."Retention Base" := PaymentsRetentionGroup."Retention Base";
            end;
            RetEntry."Retention Action" := RetEntry."Retention Action"::"Payment Hold";
            RetEntry.Description := 'Retención buena ejecución';
            RetEntry."Posting Date" := PurchHeader."Posting Date";
            RetEntry."Due Date" := CALCDATE(PaymentsRetentionGroup."Warranty Period", PurchHeader."Due Date");
            RetEntry."Document Date" := PurchHeader."Document Date";
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN
                RetEntry."Document Type" := RetEntry."Document Type"::Invoice;
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN
                RetEntry."Document Type" := RetEntry."Document Type"::"Credit Memo";
            RetEntry."Document No." := DocNo;
            RetEntry."External Document No." := ExtDocNo;
            RetEntry."Currency Code" := GenJnlLine."Currency Code";
            RetEntry."Retention Amount Base" := ABS(BaseRetentionGE);
            RetEntry."Retention Amount Base (LCY)" := ABS(BaseRetentionGE);
            RetEntry.Amount := ABS(GenJnlLine.Amount);
            RetEntry."Amount (LCY)" := ABS(GenJnlLine."Amount (LCY)");
            RetEntry.Open := TRUE;
            RetEntry."Referencia Catastral" := TotalPurchLine."Ref. catastral inmueble SII";
            RetEntry.INSERT;
        END;

        // IRPF
        IF (TotalRetentionIRPF <> 0) AND (GLAccountIRPF <> '') THEN begin
            // WITH GenJnlLine DO BEGIN
            GenJnlLine.InitNewLine(
                PurchHeader."Posting Date", PurchHeader."Document Date", PurchHeader."VAT Reporting Date", PurchHeader."Posting Description",
                PurchHeader."Shortcut Dimension 1 Code", PurchHeader."Shortcut Dimension 2 Code",
                PurchHeader."Dimension Set ID", PurchHeader."Reason Code");
            GenJnlLine.CopyDocumentFields(GenJnlLineDocType, DocNo, ExtDocNo, SourceCode, '');
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := GlAccountIRPF;
            GenJnlLine.CopyFromPurchHeader(PurchHeader);
            GenJnlLine.SetCurrencyFactor(PurchHeader."Currency Code", PurchHeader."Currency Factor");
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.CopyFromPurchHeaderApplyTo(PurchHeader);
            //"Applies-to Bill No." := PurchHeader."Applies-to Bill No.";
            GenJnlLine.CopyFromPurchHeaderPayment(PurchHeader);
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN BEGIN
                GenJnlLine.Amount := -TotalRetentionIRPF;
                GenJnlLine."Source Currency Amount" := -TotalRetentionIRPF;
            END;
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine.Amount := TotalRetentionIRPF;
                GenJnlLine."Source Currency Amount" := TotalRetentionIRPF;
            END;
            GenJnlLine."ID Type" := PurchHeader."ID Type";
            // IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN BEGIN
            //     "Applies-to Doc. Type" := "Applies-to Doc. Type"::Invoice;
            //     "Applies-to Doc. No." := DocNo;
            // END;
            // IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN BEGIN
            //     "Applies-to Doc. Type" := "Applies-to Doc. Type"::"Credit Memo";
            //     "Applies-to Doc. No." := DocNo;
            // END;
            GenJnlLine."Document Type" := GenJnlLineDocType;
            // "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
            // "Bal. Account No." := GLAccountIRPF;
            GenJnlLine."Retention IRPF" := TRUE;
            GenJnlLine."Pmt. Discount Date" := 0D;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            //
            RetEntry.RESET;
            RetEntryNewId := 1;
            IF RetEntry.FINDLAST THEN
                RetEntryNewId := RetEntry."Entry No." + 1;
            RetEntry.INIT;
            RetEntry."Entry No." := RetEntryNewId;
            RetEntry.Type := RetEntry.Type::Vendor;
            RetEntry."No." := PurchHeader."Pay-to Vendor No.";
            If PaymentsRetentionGroup.GET(PurchHeader."Código grupo retención (IRPF)") Then begin
                RetEntry."Retention Group Code" := PurchHeader."Código grupo retención (IRPF)";
                RetEntry."Retention Type" := PaymentsRetentionGroup."Retention Type";
                RetEntry."Retention Base" := PaymentsRetentionGroup."Retention Base";
            end;
            RetEntry."Retention Action" := RetEntry."Retention Action"::"Payment Hold";
            RetEntry.Description := 'Retención IRPF';
            RetEntry."Posting Date" := PurchHeader."Posting Date";
            RetEntry."Due Date" := CALCDATE(PaymentsRetentionGroup."Warranty Period", PurchHeader."Due Date");
            RetEntry."Document Date" := PurchHeader."Document Date";
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN
                RetEntry."Document Type" := RetEntry."Document Type"::Invoice;
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN
                RetEntry."Document Type" := RetEntry."Document Type"::"Credit Memo";
            RetEntry."Document No." := GenJnlLine."Document No.";
            RetEntry."External Document No." := GenJnlLine."External Document No.";
            RetEntry."Currency Code" := GenJnlLine."Currency Code";
            RetEntry."Retention Amount Base" := ABS(BaseRetentionIRPF);
            RetEntry."Retention Amount Base (LCY)" := ABS(BaseRetentionIRPF);
            RetEntry.Amount := ABS(GenJnlLine.Amount);
            RetEntry."Amount (LCY)" := ABS(GenJnlLine."Amount (LCY)");
            RetEntry.Open := TRUE;
            RetEntry."Referencia Catastral" := TotalPurchLine."Ref. catastral inmueble SII";
            RetEntry.INSERT;
        END;
    END;


#pragma warning disable AL0432 // TODO: - Revisar en la próxima versión
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCustomerEntry', '', false, false)]
#pragma warning restore AL0432 // TODO: - Revisar en la próxima versión
    local procedure OnBeforeInitGenJnlLineAmountFieldsFromTotalSalesLine(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line")
    var
        BaseRetentionIRPF: Decimal;
        TotalRetentionIRPF: Decimal;
        PaymentsRetentionGroup: Record "Grupo de retención de pagos";
        RetEntryPurchLine: Record 37;
    begin
        RetEntryPurchLine.RESET;
        RetEntryPurchLine.SETRANGE(RetEntryPurchLine."Document Type", SalesHeader."Document Type");
        RetEntryPurchLine.SETRANGE(RetEntryPurchLine."Document No.", SalesHeader."No.");
        IF RetEntryPurchLine.FINDFIRST THEN
            REPEAT
                TotalRetentionIRPF += RetEntryPurchLine."Importe retención (IRPF)";
                IF RetEntryPurchLine."Importe retención (IRPF)" <> 0 THEN
                    BaseRetentionIRPF += RetEntryPurchLine."Line Amount";
            UNTIL RetEntryPurchLine.NEXT = 0;
        IF (TotalRetentionIRPF = 0) THEN begin
            exit;
        end;
        If SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" Then begin
            TotalRetentionIRPF := -TotalRetentionIRPF;
            BaseRetentionIRPF := -BaseRetentionIRPF;

        end;
        //with GenJnlLine do begin
        GenJnlLine.Amount := -TotalSalesLine."Amount Including VAT" + (TotalRetentionIRPF) * -1;
        GenJnlLine."Source Currency Amount" := -TotalSalesLine."Amount Including VAT" + (TotalRetentionIRPF) * -1;
        GenJnlLine."Amount (LCY)" := -TotalSalesLineLCY."Amount Including VAT" + (TotalRetentionIRPF) * -1;
        GenJnlLine."Sales/Purch. (LCY)" := -TotalSalesLineLCY.Amount + BaseRetentionIRPF;
        GenJnlLine."Inv. Discount (LCY)" := -TotalSalesLineLCY."Inv. Discount Amount";
        //end;
    end;


#pragma warning disable AL0432 // TODO: - Revisar en la próxima versión
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostCustomerEntry', '', false, false)]
#pragma warning restore AL0432 // TODO: - Revisar en la próxima versión
    local procedure OnAfterPostCustomerEntry(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        BaseRetentionGE: Decimal;
        BaseRetentionIRPF: Decimal;
        TotalRetentionGE: Decimal;
        TotalRetentionIRPF: Decimal;
        PaymentsRetentionGroup: Record "Grupo de retención de pagos";
        RetEntrySalesLine: Record 37;
        GLAccountGE: Code[20];
        GLAccountIRPF: Code[20];
        RetEntry: Record "Mov. retención de pagos";
        RetEntryNewId: Integer;
        GenJnlLineDocType: Enum "Gen. Journal Document Type";
        DocNo: Code[20];
        ExtDocNo: Code[35];
        SourceCode: Code[10];
    //GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"

    BEGIN
        IF (SalesHeader."Código grupo retención (BE)" = '') And (SalesHeader."Código grupo retención (IRPF)" = '') Then exit;

        TotalRetentionGE := 0;
        TotalRetentionIRPF := 0;
        BaseRetentionGE := 0;
        BaseRetentionIRPF := 0;
        GenJnlLineDocType := GenJnlLine."Document Type";
        DocNo := GenJnlLine."Document No.";
        ExtDocNo := GenJnlLine."External Document No.";
        SourceCode := GenJnlLine."Source Code";
        // BE
        IF SalesHeader."Código grupo retención (BE)" <> '' THEN
            IF PaymentsRetentionGroup.GET(SalesHeader."Código grupo retención (BE)") THEN BEGIN
                PaymentsRetentionGroup.TESTFIELD(PaymentsRetentionGroup."Account No.");
                GLAccountGE := PaymentsRetentionGroup."Account No.";
            END;

        // IRPF
        IF SalesHeader."Código grupo retención (IRPF)" <> '' THEN
            IF PaymentsRetentionGroup.GET(SalesHeader."Código grupo retención (IRPF)") THEN BEGIN
                PaymentsRetentionGroup.TESTFIELD(PaymentsRetentionGroup."Account No.");
                GLAccountIRPF := PaymentsRetentionGroup."Account No.";
            END;


        RetEntrySalesLine.RESET;
        RetEntrySalesLine.SETRANGE(RetEntrySalesLine."Document Type", SalesHeader."Document Type");
        RetEntrySalesLine.SETRANGE(RetEntrySalesLine."Document No.", SalesHeader."No.");
        IF RetEntrySalesLine.FINDFIRST THEN
            REPEAT
                TotalRetentionGE += RetEntrySalesLine."Importe retención (BE)";
                IF RetEntrySalesLine."Importe retención (BE)" <> 0 THEN
                    BaseRetentionGE += RetEntrySalesLine."Line Amount";
                //
                TotalRetentionIRPF += RetEntrySalesLine."Importe retención (IRPF)";
                IF RetEntrySalesLine."Importe retención (IRPF)" <> 0 THEN
                    BaseRetentionIRPF += RetEntrySalesLine."Line Amount";
            UNTIL RetEntrySalesLine.NEXT = 0;

        // BE
        IF (TotalRetentionGE <> 0) AND (GLAccountGE <> '') THEN begin
            //WITH GenJnlLine DO BEGIN
            GenJnlLine.InitNewLine(
            SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."VAT Reporting Date", SalesHeader."Posting Description",
            SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code",
                SalesHeader."Dimension Set ID", SalesHeader."Reason Code");
            GenJnlLine.CopyDocumentFields(GenJnlLineDocType, DocNo, ExtDocNo, SourceCode, '');
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
            GenJnlLine."Account No." := SalesHeader."Bill-to Customer No.";
            GenJnlLine.CopyFromSalesHeader(SalesHeader);
            GenJnlLine.SetCurrencyFactor(SalesHeader."Currency Code", SalesHeader."Currency Factor");
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.CopyFromSalesHeaderApplyTo(SalesHeader);
            GenJnlLine."Applies-to Bill No." := SalesHeader."Applies-to Bill No.";
            GenJnlLine.CopyFromSalesHeaderPayment(SalesHeader);
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN BEGIN
                GenJnlLine.Amount := -TotalRetentionGE;
                GenJnlLine."Source Currency Amount" := -TotalRetentionGE;
            END;
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine.Amount := TotalRetentionGE;
                GenJnlLine."Source Currency Amount" := TotalRetentionGE;
            END;
            GenJnlLine."ID Type" := SalesHeader."ID Type";
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN BEGIN
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := DocNo;
            END;
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Credit Memo";
                GenJnlLine."Applies-to Doc. No." := DocNo;
            END;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
            if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice Then
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" Then
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := GLAccountGE;
            GenJnlLine."Retention IRPF" := TRUE;
            GenJnlLine."Pmt. Discount Date" := 0D;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            //
            RetEntry.RESET;
            RetEntryNewId := 1;
            IF RetEntry.FINDLAST THEN
                RetEntryNewId := RetEntry."Entry No." + 1;
            RetEntry.INIT;
            RetEntry."Entry No." := RetEntryNewId;
            RetEntry.Type := RetEntry.Type::Customer;
            RetEntry."No." := SalesHeader."Bill-to Customer No.";
            PaymentsRetentionGroup.GET(SalesHeader."Código grupo retención (BE)");
            RetEntry."Retention Group Code" := SalesHeader."Código grupo retención (BE)";
            RetEntry."Retention Type" := PaymentsRetentionGroup."Retention Type";
            RetEntry."Retention Base" := PaymentsRetentionGroup."Retention Base";
            RetEntry."Retention Action" := RetEntry."Retention Action"::"Payment Hold";
            RetEntry.Description := 'Retención buena ejecución';
            RetEntry."Posting Date" := SalesHeader."Posting Date";
            RetEntry."Due Date" := CALCDATE(PaymentsRetentionGroup."Warranty Period", SalesHeader."Due Date");
            RetEntry."Document Date" := SalesHeader."Document Date";
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN
                RetEntry."Document Type" := RetEntry."Document Type"::Invoice;
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN
                RetEntry."Document Type" := RetEntry."Document Type"::"Credit Memo";
            RetEntry."Document No." := DocNo;
            RetEntry."External Document No." := ExtDocNo;
            RetEntry."Currency Code" := GenJnlLine."Currency Code";
            RetEntry."Retention Amount Base" := ABS(BaseRetentionGE);
            RetEntry."Retention Amount Base (LCY)" := ABS(BaseRetentionGE);
            RetEntry.Amount := ABS(GenJnlLine.Amount);
            RetEntry."Amount (LCY)" := ABS(GenJnlLine."Amount (LCY)");
            RetEntry.Open := TRUE;
            RetEntry.INSERT;
        END;

        // IRPF
        IF (TotalRetentionIRPF <> 0) AND (GLAccountIRPF <> '') THEN begin
            //WITH GenJnlLine DO BEGIN
            GenJnlLine.InitNewLine(
            SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."VAT Reporting Date", SalesHeader."Posting Description",
            SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code",
            SalesHeader."Dimension Set ID", SalesHeader."Reason Code");
            GenJnlLine.CopyDocumentFields(GenJnlLineDocType, DocNo, ExtDocNo, SourceCode, '');
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := GlAccountIRPF;
            GenJnlLine.CopyFromSalesHeader(SalesHeader);
            GenJnlLine.SetCurrencyFactor(SalesHeader."Currency Code", SalesHeader."Currency Factor");
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.CopyFromSalesHeaderApplyTo(SalesHeader);
            //GenJnlLine."Applies-to Bill No." := SalesHeader."Applies-to Bill No.";
            GenJnlLine.CopyFromSalesHeaderPayment(SalesHeader);
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN BEGIN
                GenJnlLine.Amount := +TotalRetentionIRPF;
                GenJnlLine."Source Currency Amount" := +TotalRetentionIRPF;
            END;
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine.Amount := -TotalRetentionIRPF;
                GenJnlLine."Source Currency Amount" := -TotalRetentionIRPF;
            END;
            GenJnlLine."ID Type" := SalesHeader."ID Type";
            // IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN BEGIN
            //     GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
            //     GenJnlLine."Applies-to Doc. No." := DocNo;
            // END;
            // IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN BEGIN
            //     GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Credit Memo";
            //     GenJnlLine."Applies-to Doc. No." := DocNo;
            // END;

            // if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice Then
            //     GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
            // if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" Then
            //     GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
            GenJnlLine."Document Type" := GenJnlLineDocType;
            // GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            // GenJnlLine."Bal. Account No." := GLAccountIRPF;
            GenJnlLine."Retention IRPF" := TRUE;
            GenJnlLine."Pmt. Discount Date" := 0D;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            //
            RetEntry.RESET;
            RetEntryNewId := 1;
            IF RetEntry.FINDLAST THEN
                RetEntryNewId := RetEntry."Entry No." + 1;
            RetEntry.INIT;
            RetEntry."Entry No." := RetEntryNewId;
            RetEntry.Type := RetEntry.Type::Customer;
            RetEntry."No." := SalesHeader."Bill-to Customer No.";
            PaymentsRetentionGroup.GET(SalesHeader."Código grupo retención (IRPF)");
            RetEntry."Retention Group Code" := SalesHeader."Código grupo retención (IRPF)";
            RetEntry."Retention Type" := PaymentsRetentionGroup."Retention Type";
            RetEntry."Retention Base" := PaymentsRetentionGroup."Retention Base";
            RetEntry."Retention Action" := RetEntry."Retention Action"::"Payment Hold";
            RetEntry.Description := 'Retención Irpf';
            RetEntry."Posting Date" := SalesHeader."Posting Date";
            RetEntry."Due Date" := CALCDATE(PaymentsRetentionGroup."Warranty Period", SalesHeader."Due Date");
            RetEntry."Document Date" := SalesHeader."Document Date";
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN
                RetEntry."Document Type" := RetEntry."Document Type"::Invoice;
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN
                RetEntry."Document Type" := RetEntry."Document Type"::"Credit Memo";
            RetEntry."Document No." := GenJnlLine."Document No.";
            RetEntry."External Document No." := GenJnlLine."External Document No.";
            RetEntry."Currency Code" := GenJnlLine."Currency Code";
            RetEntry."Retention Amount Base" := ABS(BaseRetentionIRPF);
            RetEntry."Retention Amount Base (LCY)" := ABS(BaseRetentionIRPF);
            RetEntry.Amount := ABS(GenJnlLine.Amount);
            RetEntry."Amount (LCY)" := ABS(GenJnlLine."Amount (LCY)");
            RetEntry.Open := TRUE;
            RetEntry.INSERT;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Bill-to Customer No.', false, false)]
    LOCAL PROCEDURE "OnAfterValidateEvent_SalesHeader_Bill-toCustomerNo._GetOnHold"(VAR Rec: Record 36; VAR xRec: Record 36; CurrFieldNo: Integer);
    VAR
        Customer: Record 18;
    BEGIN

        IF (xRec."Bill-to Customer No." <> Rec."Bill-to Customer No.") AND (Rec."Bill-to Customer No." <> '') THEN BEGIN
            Customer.GET(Rec."Bill-to Customer No.");
            Rec.VALIDATE(Rec."Código grupo retención (BE)", Customer."Código grupo retención (BE)");
            Rec.VALIDATE(Rec."Código grupo retención (IRPF)", Customer."Código grupo retención (IRPF)");
        END;
    END;

    [EventSubscriber(ObjectType::Page, 344, 'OnAfterNavigateShowRecords', '', false, false)]
    local procedure OnAfterNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; var TempDocumentEntry: Record "Document Entry" temporary; SalesInvoiceHeader: Record "Sales Invoice Header"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; PurchInvHeader: Record "Purch. Inv. Header"; PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; ServiceInvoiceHeader: Record "Service Invoice Header"; ServiceCrMemoHeader: Record "Service Cr.Memo Header"; ContactType: Enum "Navigate Contact Type"; ContactNo: Code[250]; ExtDocNo: Code[250])
    var
        Ret: Record "Mov. retención de pagos";
    begin
        If TableID = Database::"Mov. retención de pagos" Then begin
            Ret.Setfilter("Document No.", DocNoFilter);
            Page.RunModal(0, Ret);
        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'No.', false, false)]
    LOCAL PROCEDURE "OnAfterValidateEvent_SalesLine_No._GetOnHold"(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        SalesHeader: Record 36;
        OnHoldGroup: Record "Grupo de retención de pagos";
    BEGIN

        IF (xRec."No." <> Rec."No.") AND (Rec."No." <> '') THEN BEGIN
            SalesHeader.GET(Rec."Document Type", Rec."Document No.");
            IF SalesHeader."Código grupo retención (BE)" <> '' THEN
                IF OnHoldGroup.GET(SalesHeader."Código grupo retención (BE)") THEN
                    Rec.VALIDATE(Rec."% retención (BE)", OnHoldGroup."% Retention");
            IF SalesHeader."Código grupo retención (IRPF)" <> '' THEN
                IF OnHoldGroup.GET(SalesHeader."Código grupo retención (IRPF)") THEN
                    Rec.VALIDATE(Rec."% retención (IRPF)", OnHoldGroup."% Retention");
        END;
    END;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', '% retención (BE)', false, false)]
    LOCAL PROCEDURE "OnAfterValidateEvent_SalesLine_%GE._GetOnHold"(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        SalesHeader: Record 36;
        GeneralLedgerSetup: Record 98;
        Currency: Record 4;
        AmountRoundingPrecision: Decimal;
    BEGIN

        SalesHeader.GET(Rec."Document Type", Rec."Document No.");
        IF SalesHeader."Currency Code" = '' THEN BEGIN
            GeneralLedgerSetup.GET;
            GeneralLedgerSetup.TESTFIELD("Amount Rounding Precision");
            AmountRoundingPrecision := GeneralLedgerSetup."Amount Rounding Precision";
        END
        ELSE BEGIN
            Currency.GET(SalesHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
            AmountRoundingPrecision := Currency."Amount Rounding Precision";
        END;
        Rec.VALIDATE("Importe retención (BE)", ROUND(Rec."Line Amount" * Rec."% retención (BE)" / 100, AmountRoundingPrecision));
    END;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', '% retención (IRPF)', false, false)]
    LOCAL PROCEDURE "OnAfterValidateEvent_SalesLine_%IRPF._GetOnHold"(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    VAR
        SalesHeader: Record 36;
        GeneralLedgerSetup: Record 98;
        Currency: Record 4;
        AmountRoundingPrecision: Decimal;
    BEGIN

        SalesHeader.GET(Rec."Document Type", Rec."Document No.");
        IF SalesHeader."Currency Code" = '' THEN BEGIN
            GeneralLedgerSetup.GET;
            GeneralLedgerSetup.TESTFIELD("Amount Rounding Precision");
            AmountRoundingPrecision := GeneralLedgerSetup."Amount Rounding Precision";
        END
        ELSE BEGIN
            Currency.GET(SalesHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
            AmountRoundingPrecision := Currency."Amount Rounding Precision";
        END;
        Rec.VALIDATE("Importe retención (IRPF)", ROUND(Rec."Line Amount" * Rec."% retención (IRPF)" / 100, AmountRoundingPrecision));
    END;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Line Amount', false, false)]
    LOCAL PROCEDURE OnAfterValidateEvent_SalesLine_LineAmount_GetOnHold(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    BEGIN

        Rec.VALIDATE("% retención (BE)");
        Rec.VALIDATE("% retención (IRPF)");
    END;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Quantity', false, false)]
    LOCAL PROCEDURE OnAfterValidateEvent_SalesLine_Quantity_GetOnHold(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    BEGIN

        Rec.VALIDATE("% retención (BE)");
        Rec.VALIDATE("% retención (IRPF)");
    END;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Unit Price', false, false)]
    LOCAL PROCEDURE OnAfterValidateEvent_SalesLine_DirectUnitCost_GetOnHold(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    BEGIN

        Rec.VALIDATE("% retención (BE)");
        Rec.VALIDATE("% retención (IRPF)");
    END;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    LOCAL PROCEDURE "OnAfterValidateEvent_SalesLine_LineDiscount%_GetOnHold"(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    BEGIN

        Rec.VALIDATE("% retención (BE)");
        Rec.VALIDATE("% retención (IRPF)");
    END;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Line Discount Amount', false, false)]
    LOCAL PROCEDURE OnAfterValidateEvent_SalesLine_LineDiscountAmount_GetOnHold(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    BEGIN

        Rec.VALIDATE("% retención (BE)");
        Rec.VALIDATE("% retención (IRPF)");
    END;


    [EventSubscriber(ObjectType::Table, 38, 'OnBeforeValidateEvent', 'Buy-from Vendor No.', false, false)]
    LOCAL PROCEDURE "OnAfterValidateEvent_PurchaseHeader_Buy-fromVendorNo._GetOnHold"(VAR Rec: Record 38; VAR xRec: Record 38; CurrFieldNo: Integer);
    VAR
        Vendor: Record 23;
    BEGIN

        IF (xRec."Buy-from Vendor No." <> Rec."Buy-from Vendor No.") AND (Rec."Buy-from Vendor No." <> '') THEN BEGIN
            Vendor.GET(Rec."Buy-from Vendor No.");
            Rec.VALIDATE(Rec."Código grupo retención (BE)", Vendor."Código grupo retención (BE)");
            Rec.VALIDATE(Rec."Código grupo retención (IRPF)", Vendor."Código grupo retención (IRPF)");
        END;
    END;


    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'No.', false, false)]
    LOCAL PROCEDURE "OnAfterValidateEvent_PurchaseLine_No._GetOnHold"(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        PurchaseHeader: Record 38;
        OnHoldGroup: Record "Grupo de retención de pagos";
    BEGIN

        IF (xRec."No." <> Rec."No.") AND (Rec."No." <> '') THEN BEGIN
            PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
            IF PurchaseHeader."Código grupo retención (BE)" <> '' THEN
                IF OnHoldGroup.GET(PurchaseHeader."Código grupo retención (BE)") THEN
                    Rec.VALIDATE(Rec."% retención (BE)", OnHoldGroup."% Retention");
            IF PurchaseHeader."Código grupo retención (IRPF)" <> '' THEN
                IF OnHoldGroup.GET(PurchaseHeader."Código grupo retención (IRPF)") THEN
                    Rec.VALIDATE(Rec."% retención (IRPF)", OnHoldGroup."% Retention");
        END;
    END;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', '% retención (BE)', false, false)]
    LOCAL PROCEDURE "OnAfterValidateEvent_PurchaseLine_%GE._GetOnHold"(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        PurchaseHeader: Record 38;
        GeneralLedgerSetup: Record 98;
        Currency: Record 4;
        AmountRoundingPrecision: Decimal;
    BEGIN

        PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
        IF PurchaseHeader."Currency Code" = '' THEN BEGIN
            GeneralLedgerSetup.GET;
            GeneralLedgerSetup.TESTFIELD("Amount Rounding Precision");
            AmountRoundingPrecision := GeneralLedgerSetup."Amount Rounding Precision";
        END
        ELSE BEGIN
            Currency.GET(PurchaseHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
            AmountRoundingPrecision := Currency."Amount Rounding Precision";
        END;
        Rec.VALIDATE("Importe retención (BE)", ROUND(Rec."Line Amount" * Rec."% retención (BE)" / 100, AmountRoundingPrecision));
    END;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', '% retención (IRPF)', false, false)]
    LOCAL PROCEDURE "OnAfterValidateEvent_PurchaseLine_%IRPF._GetOnHold"(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    VAR
        PurchaseHeader: Record 38;
        GeneralLedgerSetup: Record 98;
        Currency: Record 4;
        AmountRoundingPrecision: Decimal;
    BEGIN

        PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
        IF PurchaseHeader."Currency Code" = '' THEN BEGIN
            GeneralLedgerSetup.GET;
            GeneralLedgerSetup.TESTFIELD("Amount Rounding Precision");
            AmountRoundingPrecision := GeneralLedgerSetup."Amount Rounding Precision";
        END
        ELSE BEGIN
            Currency.GET(PurchaseHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
            AmountRoundingPrecision := Currency."Amount Rounding Precision";
        END;
        Rec.VALIDATE("Importe retención (IRPF)", ROUND(Rec."Line Amount" * Rec."% retención (IRPF)" / 100, AmountRoundingPrecision));
    END;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Line Amount', false, false)]
    LOCAL PROCEDURE OnAfterValidateEvent_PurchaseLine_LineAmount_GetOnHold(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    BEGIN

        Rec.VALIDATE("% retención (BE)");
        Rec.VALIDATE("% retención (IRPF)");
    END;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Quantity', false, false)]
    LOCAL PROCEDURE OnAfterValidateEvent_PurchaseLine_Quantity_GetOnHold(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    BEGIN

        Rec.VALIDATE("% retención (BE)");
        Rec.VALIDATE("% retención (IRPF)");
    END;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Direct Unit Cost', false, false)]
    LOCAL PROCEDURE OnAfterValidateEvent_PurchaseLine_DirectUnitCost_GetOnHold(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    BEGIN

        Rec.VALIDATE("% retención (BE)");
        Rec.VALIDATE("% retención (IRPF)");
    END;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    LOCAL PROCEDURE "OnAfterValidateEvent_PurchaseLine_LineDiscount%_GetOnHold"(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    BEGIN

        Rec.VALIDATE("% retención (BE)");
        Rec.VALIDATE("% retención (IRPF)");
    END;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Line Discount Amount', false, false)]
    LOCAL PROCEDURE OnAfterValidateEvent_PurchaseLine_LineDiscountAmount_GetOnHold(VAR Rec: Record 39; VAR xRec: Record 39; CurrFieldNo: Integer);
    BEGIN

        Rec.VALIDATE("% retención (BE)");
        Rec.VALIDATE("% retención (IRPF)");
    END;
    #endregion Irpf

    //Fin Eventos

}