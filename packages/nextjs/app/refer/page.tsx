"use client";

import { NextPage } from "next";
import { formatEther } from "viem";
import { Address } from "~~/components/scaffold-eth";
import { useScaffoldEventHistory } from "~~/hooks/scaffold-eth";

const Refer: NextPage = () => {
  const { data: referrals, isLoading: referralsLoading } = useScaffoldEventHistory({
    contractName: "Referral",
    eventName: "ReferralRegistered",
    fromBlock: 0n,
  });

  const { data: rewards, isLoading: rewardsLoading } = useScaffoldEventHistory({
    contractName: "Referral",
    eventName: "RewardDistributed",
    fromBlock: 0n,
  });

  return (
    <div className="flex items-center flex-col flex-grow pt-10">
      {/* BuyTokens Events */}
      <div>
        <div className="text-center mb-4">
          <span className="block text-2xl font-bold">Referrals</span>
        </div>
        {referralsLoading ? (
          <div className="flex justify-center items-center mt-8">
            <span className="loading loading-spinner loading-lg"></span>
          </div>
        ) : (
          <div className="overflow-x-auto shadow-lg">
            <table className="table table-zebra w-full">
              <thead>
                <tr>
                  <th className="bg-primary">User</th>
                  <th className="bg-primary"> - </th>
                  <th className="bg-primary">New User</th>
                </tr>
              </thead>
              <tbody>
                {!referrals || referrals.length === 0 ? (
                  <tr>
                    <td colSpan={3} className="text-center">
                      No events found
                    </td>
                  </tr>
                ) : (
                  referrals?.map((event, index) => {
                    return (
                      <tr key={index}>
                        <td className="text-center">
                          <Address address={event.args.referrer} />
                        </td>
                        <td>referred</td>
                        <td>
                          <Address address={event.args.user} />
                        </td>
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* SellTokens Events */}
      <div className="mt-14">
        <div className="text-center mb-4">
          <span className="block text-2xl font-bold">Rewards</span>
        </div>
        {rewardsLoading ? (
          <div className="flex justify-center items-center mt-8">
            <span className="loading loading-spinner loading-lg"></span>
          </div>
        ) : (
          <div className="overflow-x-auto shadow-lg">
            <table className="table table-zebra w-full">
              <thead>
                <tr>
                  <th className="bg-primary">Referrer</th>
                  <th className="bg-primary">Referrals</th>
                  <th className="bg-primary">Amount of REF</th>
                </tr>
              </thead>
              <tbody>
                {!rewards || rewards.length === 0 ? (
                  <tr>
                    <td colSpan={3} className="text-center">
                      No events found
                    </td>
                  </tr>
                ) : (
                  rewards?.map((event, index) => {
                    return (
                      <tr key={index}>
                        <td className="text-center">
                          <Address address={event.args.referrer} />
                        </td>
                        <td> - </td>
                        <td>{formatEther(event.args?.amount || 0n)}</td>
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};

export default Refer;
