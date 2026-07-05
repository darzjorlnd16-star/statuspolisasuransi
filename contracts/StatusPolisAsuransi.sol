// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InsurancePolicy {

    // Pemilik kontrak (Perusahaan Asuransi)
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Hanya perusahaan yang dapat mengakses.");
        _;
    }

    enum PolicyStatus {
        Aktif,
        Cair
    }

    struct Policy {
        uint policyId;
        string customerName;
        address customerAddress;
        uint premium;
        PolicyStatus status;
        bool exists;
    }

    mapping(uint => Policy) public policies;

    event PolicyCreated(
        uint policyId,
        string customerName,
        address customerAddress
    );

    event StatusUpdated(
        uint policyId,
        PolicyStatus status
    );

    // Membuat Polis Baru
    function createPolicy(
        uint _policyId,
        string memory _customerName,
        address _customerAddress,
        uint _premium
    ) public onlyOwner {

        require(!policies[_policyId].exists, "Policy sudah ada.");

        policies[_policyId] = Policy({
            policyId: _policyId,
            customerName: _customerName,
            customerAddress: _customerAddress,
            premium: _premium,
            status: PolicyStatus.Aktif,
            exists: true
        });

        emit PolicyCreated(
            _policyId,
            _customerName,
            _customerAddress
        );
    }

    // Mengubah Status Polis Menjadi Aktif
    function setPolicyActive(uint _policyId) public onlyOwner {
        require(policies[_policyId].exists, "Policy tidak ditemukan.");

        policies[_policyId].status = PolicyStatus.Aktif;

        emit StatusUpdated(
            _policyId,
            PolicyStatus.Aktif
        );
    }

    // Mengubah Status Polis Menjadi Cair
    function setPolicyClaimed(uint _policyId) public onlyOwner {
        require(policies[_policyId].exists, "Policy tidak ditemukan.");

        policies[_policyId].status = PolicyStatus.Cair;

        emit StatusUpdated(
            _policyId,
            PolicyStatus.Cair
        );
    }

    // Melihat Status Polis
    function checkPolicyStatus(uint _policyId)
        public
        view
        returns(string memory)
    {
        require(policies[_policyId].exists, "Policy tidak ditemukan.");

        if (policies[_policyId].status == PolicyStatus.Aktif) {
            return "Aktif";
        } else {
            return "Cair";
        }
    }

    // Melihat Detail Polis
    function getPolicy(uint _policyId)
        public
        view
        returns(
            uint,
            string memory,
            address,
            uint,
            string memory
        )
    {
        require(policies[_policyId].exists, "Policy tidak ditemukan.");

        Policy memory p = policies[_policyId];

        string memory statusText;

        if (p.status == PolicyStatus.Aktif) {
            statusText = "Aktif";
        } else {
            statusText = "Cair";
        }

        return (
            p.policyId,
            p.customerName,
            p.customerAddress,
            p.premium,
            statusText
        );
    }
}